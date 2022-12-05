/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include "DropArea.h"
#include "Config.h"
#include "kddockwidgets/ViewFactory.h"
#include "DockRegistry.h"
#include "Platform.h"
#include "private/Draggable_p.h"
#include "private/Logging_p.h"
#include "private/Utils_p.h"
#include "private/multisplitter/Item_p.h"
#include "private/WindowBeingDragged_p.h"

#include "controllers/Group.h"
#include "controllers/FloatingWindow.h"
#include "controllers/DockWidget.h"
#include "controllers/DockWidget_p.h"
#include "controllers/MainWindow.h"
#include "controllers/DropIndicatorOverlay.h"
#include "controllers/indicators/ClassicIndicators.h"
#include "controllers/indicators/NullIndicators.h"
#include "controllers/indicators/SegmentedIndicators.h"

#include "Window.h"

#include <algorithm>

using namespace KDDockWidgets;
using namespace KDDockWidgets::Controllers;

namespace KDDockWidgets {
static Controllers::DropIndicatorOverlay *
createDropIndicatorOverlay(Controllers::DropArea *dropArea)
{
#ifdef Q_OS_WASM
    // On WASM windows don't support translucency, which is required for the classic indicators.
    return new SegmentedIndicators(dropArea);
#endif

    switch (ViewFactory::s_dropIndicatorType) {
    case DropIndicatorType::Classic:
        return new Controllers::ClassicIndicators(dropArea);
    case DropIndicatorType::Segmented:
        return new Controllers::SegmentedIndicators(dropArea);
    case DropIndicatorType::None:
        return new Controllers::NullIndicators(dropArea);
    }

    return new Controllers::ClassicIndicators(dropArea);
}
}

DropArea::DropArea(View *parent, MainWindowOptions options, bool isMDIWrapper)
    : Layout(Type::DropArea, Config::self().viewFactory()->createDropArea(this, parent))
    , m_isMDIWrapper(isMDIWrapper)
    , m_dropIndicatorOverlay(createDropIndicatorOverlay(this))
    , m_centralFrame(createCentralFrame(options))
{
    setRootItem(new Layouting::ItemBoxContainer(view()));
    DockRegistry::self()->registerLayout(this);

    if (parent)
        setLayoutSize(parent->size());

    // Initialize min size
    updateSizeConstraints();

    qCDebug(creation) << "DropArea";

    if (m_isMDIWrapper) {
        m_visibleWidgetCountConnection = visibleWidgetCountChanged.connect([this] {
            auto dw = mdiDockWidgetWrapper();
            if (!dw) {
                qWarning() << Q_FUNC_INFO << "Unexpected null wrapper dock widget";
                return;
            }

            if (visibleCount() > 0) {
                // The title of our MDI group will need to change to the app name if we have more
                // than 1 dock widget nested
                Q_EMIT dw->titleChanged(dw->title());
            } else {
                // Our wrapeper isn't needed anymore
                dw->deleteLater();
            }
        });
    }

    if (m_centralFrame)
        addWidget(m_centralFrame->view(), KDDockWidgets::Location_OnTop, {});
}

DropArea::~DropArea()
{
    m_inDestructor = true;
    delete m_dropIndicatorOverlay;
    qCDebug(creation) << "~DropArea";
}

Controllers::Group::List DropArea::groups() const
{
    const Layouting::Item::List children = m_rootItem->items_recursive();
    Controllers::Group::List groups;

    for (const Layouting::Item *child : children) {
        if (auto view = child->guestView()) {
            if (!view->freed()) {
                if (auto group = view->asGroupController()) {
                    groups << group;
                }
            }
        }
    }

    return groups;
}

Controllers::Group *DropArea::groupContainingPos(QPoint globalPos) const
{
    const Layouting::Item::List &items = this->items();
    for (Layouting::Item *item : items) {
        auto group = item->asGroupController();
        if (!group || !group->isVisible()) {
            continue;
        }

        if (group->containsMouse(globalPos))
            return group;
    }
    return nullptr;
}

void DropArea::updateFloatingActions()
{
    const Controllers::Group::List groups = this->groups();
    for (Controllers::Group *group : groups)
        group->updateFloatingActions();
}

Layouting::Item *DropArea::centralFrame() const
{
    for (Layouting::Item *item : this->items()) {
        if (auto group = item->asGroupController()) {
            if (group->isCentralFrame())
                return item;
        }
    }
    return nullptr;
}

void DropArea::addDockWidget(Controllers::DockWidget *dw, Location location,
                             Controllers::DockWidget *relativeTo, InitialOption option)
{
    if (!dw || dw == relativeTo || location == Location_None) {
        qWarning() << Q_FUNC_INFO << "Invalid parameters" << dw << relativeTo << location;
        return;
    }

    if ((option.visibility == InitialVisibilityOption::StartHidden) && dw->d->group() != nullptr) {
        // StartHidden is just to be used at startup, not to moving stuff around
        qWarning() << Q_FUNC_INFO << "Dock widget already exists in the layout";
        return;
    }

    if (!validateAffinity(dw))
        return;

    Controllers::DockWidget::Private::UpdateActions actionsUpdater(dw);

    Controllers::Group *group = nullptr;
    Controllers::Group *relativeToFrame = relativeTo ? relativeTo->d->group() : nullptr;

    dw->d->saveLastFloatingGeometry();

    const bool hadSingleFloatingFrame = hasSingleFloatingFrame();

    // Check if the dock widget already exists in the layout
    if (containsDockWidget(dw)) {
        Controllers::Group *oldFrame = dw->d->group();
        if (oldFrame->hasSingleDockWidget()) {
            Q_ASSERT(oldFrame->containsDockWidget(dw));
            // The group only has this dock widget, and the group is already in the layout. So move
            // the group instead
            group = oldFrame;
        } else {
            group = new Controllers::Group();
            group->addTab(dw);
        }
    } else {
        group = new Controllers::Group();
        group->addTab(dw);
    }

    if (option.startsHidden()) {
        addWidget(dw->view(), location, relativeToFrame, option);
    } else {
        addWidget(group->view(), location, relativeToFrame, option);
    }

    if (hadSingleFloatingFrame && !hasSingleFloatingFrame()) {
        // The dock widgets that already existed in our layout need to have their floatAction()
        // updated otherwise it's still checked. Only the dropped dock widget got updated
        updateFloatingActions();
    }
}

bool DropArea::containsDockWidget(Controllers::DockWidget *dw) const
{
    return dw->d->group() && Layout::containsFrame(dw->d->group());
}

bool DropArea::hasSingleFloatingFrame() const
{
    const Controllers::Group::List groups = this->groups();
    return groups.size() == 1 && groups.first()->isFloating();
}

bool DropArea::hasSingleFrame() const
{
    return visibleCount() == 1;
}

QStringList DropArea::affinities() const
{
    if (auto mw = mainWindow()) {
        return mw->affinities();
    } else if (auto fw = floatingWindow()) {
        return fw->affinities();
    }

    return {};
}

void DropArea::layoutParentContainerEqually(Controllers::DockWidget *dw)
{
    Layouting::Item *item = itemForFrame(dw->d->group());
    if (!item) {
        qWarning() << Q_FUNC_INFO << "Item not found for" << dw << dw->d->group();
        return;
    }

    layoutEqually(item->parentBoxContainer());
}

DropLocation DropArea::hover(WindowBeingDragged *draggedWindow, QPoint globalPos)
{
    if (Config::self().dropIndicatorsInhibited() || !validateAffinity(draggedWindow))
        return DropLocation_None;

    if (!m_dropIndicatorOverlay) {
        qWarning() << Q_FUNC_INFO << "The frontend is missing a drop indicator overlay";
        return DropLocation_None;
    }

    Controllers::Group *group = groupContainingPos(
        globalPos); // Group is nullptr if MainWindowOption_HasCentralFrame isn't set
    m_dropIndicatorOverlay->setWindowBeingDragged(true);
    m_dropIndicatorOverlay->setHoveredFrame(group);
    return m_dropIndicatorOverlay->hover(globalPos);
}

static bool isOutterLocation(DropLocation location)
{
    switch (location) {
    case DropLocation_OutterLeft:
    case DropLocation_OutterTop:
    case DropLocation_OutterRight:
    case DropLocation_OutterBottom:
        return true;
    default:
        return false;
    }
}

bool DropArea::drop(WindowBeingDragged *droppedWindow, QPoint globalPos)
{
    Controllers::FloatingWindow *floatingWindow = droppedWindow->floatingWindow();

    if (!floatingWindow) {
        qWarning() << Q_FUNC_INFO << "Expected floating window controller";
        return false;
    }

    if (!floatingWindow->view()) {
        qWarning() << Q_FUNC_INFO << "Expected floating window view";
        return false;
    }

    if (floatingWindow->view()->equals(window())) {
        qWarning() << "Refusing to drop onto itself"; // Doesn't happen
        return false;
    }

    if (m_dropIndicatorOverlay->currentDropLocation() == DropLocation_None) {
        qCDebug(hovering) << "DropArea::drop: bailing out, drop location = none";
        return false;
    }

    qCDebug(dropping) << "DropArea::drop:" << droppedWindow;

    hover(droppedWindow, globalPos);
    auto droploc = m_dropIndicatorOverlay->currentDropLocation();
    Controllers::Group *acceptingGroup = m_dropIndicatorOverlay->hoveredFrame();
    if (!(acceptingGroup || isOutterLocation(droploc))) {
        qWarning() << "DropArea::drop: asserted with group=" << acceptingGroup
                   << "; Location=" << droploc;
        return false;
    }

    return drop(droppedWindow, acceptingGroup, droploc);
}

bool DropArea::drop(WindowBeingDragged *draggedWindow, Controllers::Group *acceptingGroup,
                    DropLocation droploc)
{
    Controllers::FloatingWindow *droppedWindow =
        draggedWindow ? draggedWindow->floatingWindow() : nullptr;

    if (isWayland() && !droppedWindow) {
        // This is the Wayland special case.
        // With other platforms, when detaching a tab or dock widget we create the FloatingWindow
        // immediately. With Wayland we delay the floating window until we drop it. Ofc, we could
        // just dock the dockwidget without the temporary FloatingWindow, but this way we reuse 99%
        // of the rest of the code, without adding more wayland special cases
        droppedWindow =
            draggedWindow ? draggedWindow->draggable()->makeWindow()->floatingWindow() : nullptr;
        if (!droppedWindow) {
            // Doesn't happen
            qWarning() << Q_FUNC_INFO << "Wayland: Expected window" << draggedWindow;
            return false;
        }
    }

    bool result = true;
    const bool needToFocusNewlyDroppedWidgets =
        Config::self().flags() & Config::Flag_TitleBarIsFocusable;
    const Controllers::DockWidget::List droppedDockWidgets = needToFocusNewlyDroppedWidgets
        ? droppedWindow->layout()->dockWidgets()
        : Controllers::DockWidget::List(); // just so save some memory allocations for the case
                                           // where this
    // variable isn't used

    switch (droploc) {
    case DropLocation_Left:
    case DropLocation_Top:
    case DropLocation_Bottom:
    case DropLocation_Right:
        result = drop(droppedWindow->view(),
                      DropIndicatorOverlay::multisplitterLocationFor(droploc), acceptingGroup);
        break;
    case DropLocation_OutterLeft:
    case DropLocation_OutterTop:
    case DropLocation_OutterRight:
    case DropLocation_OutterBottom:
        result = drop(droppedWindow->view(),
                      DropIndicatorOverlay::multisplitterLocationFor(droploc), nullptr);
        break;
    case DropLocation_Center:
        qCDebug(hovering) << "Tabbing" << droppedWindow << "into" << acceptingGroup;
        if (!validateAffinity(droppedWindow, acceptingGroup))
            return false;
        acceptingGroup->addTab(droppedWindow);
        break;

    default:
        qWarning() << "DropArea::drop: Unexpected drop location"
                   << m_dropIndicatorOverlay->currentDropLocation();
        result = false;
        break;
    }

    if (result) {
        // Window receiving the drop gets raised
        // Window receiving the drop gets raised.
        // Exception: Under EGLFS we don't raise the fullscreen main window, as then all floating
        // windows would go behind. It's also unneeded to raise, as it's fullscreen.

        const bool isEGLFSRootWindow =
            isEGLFS() && (view()->window()->isFullScreen() || window()->isMaximized());
        if (!isEGLFSRootWindow)
            view()->raiseAndActivate();

        if (needToFocusNewlyDroppedWidgets) {
            // Let's also focus the newly dropped dock widget
            if (!droppedDockWidgets.isEmpty()) {
                // If more than 1 was dropped, we only focus the first one
                Controllers::Group *group = droppedDockWidgets.first()->d->group();
                group->FocusScope::focus(Qt::MouseFocusReason);
            } else {
                // Doesn't happen.
                qWarning() << Q_FUNC_INFO << "Nothing was dropped?";
            }
        }
    }

    return result;
}

bool DropArea::drop(View *droppedWindow, KDDockWidgets::Location location,
                    Controllers::Group *relativeTo)
{
    qCDebug(docking) << "DropArea::addFrame";

    if (auto dock = droppedWindow->asDockWidgetController()) {
        if (!validateAffinity(dock))
            return false;

        auto group = new Controllers::Group();
        group->addTab(dock);
        addWidget(group->view(), location, relativeTo, DefaultSizeMode::FairButFloor);
    } else if (auto floatingWindow = droppedWindow->asFloatingWindowController()) {
        if (!validateAffinity(floatingWindow))
            return false;

        const bool hadSingleFloatingFrame = hasSingleFloatingFrame();
        addMultiSplitter(floatingWindow->dropArea(), location, relativeTo,
                         DefaultSizeMode::FairButFloor);
        if (hadSingleFloatingFrame != hasSingleFloatingFrame())
            updateFloatingActions();

        floatingWindow->scheduleDeleteLater();
        return true;
    } else {
        qWarning() << "Unknown dropped widget" << droppedWindow;
        return false;
    }

    return true;
}

void DropArea::removeHover()
{
    m_dropIndicatorOverlay->removeHover();
}

template<typename T>
bool DropArea::validateAffinity(T *window, Controllers::Group *acceptingGroup) const
{
    if (!DockRegistry::self()->affinitiesMatch(window->affinities(), affinities())) {
        return false;
    }

    if (acceptingGroup) {
        // We're dropping into another group (as tabbed), so also check the affinity of the group
        // not only of the main window, which might be more forgiving
        if (!DockRegistry::self()->affinitiesMatch(window->affinities(),
                                                   acceptingGroup->affinities())) {
            return false;
        }
    }

    return true;
}

bool DropArea::isMDIWrapper() const
{
    return m_isMDIWrapper;
}

Controllers::DockWidget *DropArea::mdiDockWidgetWrapper() const
{
    if (m_isMDIWrapper) {
        return view()->parentView()->asDockWidgetController();
    }

    return nullptr;
}

Controllers::Group *DropArea::createCentralFrame(MainWindowOptions options)
{
    Controllers::Group *group = nullptr;

    if (options & MainWindowOption_HasCentralFrame) {
        FrameOptions groupOptions = FrameOption_IsCentralFrame;
        const bool hasPersistentCentralWidget =
            (options & MainWindowOption_HasCentralWidget) == MainWindowOption_HasCentralWidget;
        if (hasPersistentCentralWidget) {
            groupOptions |= FrameOption_NonDockable;
        } else {
            // With a persistent central widget we don't allow detaching it
            groupOptions |= FrameOption_AlwaysShowsTabs;
        }

        group = new Controllers::Group(nullptr, groupOptions);
        group->setObjectName(QStringLiteral("central group"));
    }

    return group;
}


bool DropArea::validateInputs(View *widget, Location location,
                              const Controllers::Group *relativeToFrame, InitialOption option) const
{
    if (!widget) {
        qWarning() << Q_FUNC_INFO << "Widget is null";
        return false;
    }

    const bool isDockWidget = widget->is(Type::DockWidget);
    const bool isStartHidden = option.startsHidden();

    const bool isLayout = widget->is(Type::DropArea) || widget->is(Type::MDILayout);
    if (!widget->is(Type::Frame) && !isLayout && !isDockWidget) {
        qWarning() << Q_FUNC_INFO << "Unknown widget type" << widget;
        return false;
    }

    if (isDockWidget != isStartHidden) {
        qWarning() << Q_FUNC_INFO << "Wrong parameters" << isDockWidget << isStartHidden;
        return false;
    }

    if (relativeToFrame && relativeToFrame->view()->equals(widget)) {
        qWarning() << Q_FUNC_INFO << "widget can't be relative to itself";
        return false;
    }

    Layouting::Item *item = itemForFrame(widget->asGroupController());

    if (containsItem(item)) {
        qWarning() << Q_FUNC_INFO << "DropArea::addWidget: Already contains" << widget;
        return false;
    }

    if (location == Location_None) {
        qWarning() << Q_FUNC_INFO << "DropArea::addWidget: not adding to location None";
        return false;
    }

    const bool relativeToThis = relativeToFrame == nullptr;

    Layouting::Item *relativeToItem = itemForFrame(relativeToFrame);
    if (!relativeToThis && !containsItem(relativeToItem)) {
        qWarning() << "DropArea::addWidget: Doesn't contain relativeTo:"
                   << "; relativeToFrame=" << relativeToFrame
                   << "; relativeToItem=" << relativeToItem << "; options=" << option;
        return false;
    }

    return true;
}

void DropArea::addWidget(View *w, Location location, Controllers::Group *relativeToWidget,
                         InitialOption option)
{

    auto group = w->asGroupController();
    if (itemForFrame(group) != nullptr) {
        // Item already exists, remove it.
        // Changing the group parent will make the item clean itself up. It turns into a placeholder
        // and is removed by unrefOldPlaceholders
        group->setParentView(nullptr); // so ~Item doesn't delete it
        group->setLayoutItem(nullptr); // so Item is destroyed, as there's no refs to it
    }

    // Make some sanity checks:
    if (!validateInputs(w, location, relativeToWidget, option))
        return;

    Layouting::Item *relativeTo = itemForFrame(relativeToWidget);
    if (!relativeTo)
        relativeTo = m_rootItem;

    Layouting::Item *newItem = nullptr;

    Controllers::Group::List groups = groupsFrom(w);
    unrefOldPlaceholders(groups);
    auto dw = w->asDockWidgetController();
    auto thisView = view();

    if (group) {
        newItem = new Layouting::Item(thisView);
        newItem->setGuestView(group->view());
    } else if (dw) {
        newItem = new Layouting::Item(thisView);
        group = new Controllers::Group();
        newItem->setGuestView(group->view());
        group->addTab(dw, option);
    } else if (auto ms = w->asDropAreaController()) {
        newItem = ms->m_rootItem;
        newItem->setHostView(thisView);

        if (auto fw = ms->floatingWindow()) {
            newItem->setSize_recursive(fw->size());
        }

        delete ms;
    } else {
        // This doesn't happen but let's make coverity happy.
        // Tests will fail if this is ever printed.
        qWarning() << Q_FUNC_INFO << "Unknown widget added" << w;
        return;
    }

    Q_ASSERT(!newItem->geometry().isEmpty());
    Layouting::ItemBoxContainer::insertItemRelativeTo(newItem, relativeTo, location, option);

    if (dw && option.startsHidden())
        delete group;
}

void DropArea::addMultiSplitter(Controllers::DropArea *sourceMultiSplitter, Location location,
                                Controllers::Group *relativeTo, InitialOption option)
{
    qCDebug(addwidget) << Q_FUNC_INFO << sourceMultiSplitter << location << relativeTo;
    addWidget(sourceMultiSplitter->view(), location, relativeTo, option);
}

QVector<Controllers::Separator *> DropArea::separators() const
{
    return m_rootItem->separators_recursive();
}

int DropArea::availableLengthForOrientation(Qt::Orientation orientation) const
{
    if (orientation == Qt::Vertical)
        return availableSize().height();
    else
        return availableSize().width();
}

QSize DropArea::availableSize() const
{
    return m_rootItem->availableSize();
}

void DropArea::layoutEqually()
{
    if (!checkSanity())
        return;

    layoutEqually(m_rootItem);
}

void DropArea::layoutEqually(Layouting::ItemBoxContainer *container)
{
    if (container) {
        container->layoutEqually_recursive();
    } else {
        qWarning() << Q_FUNC_INFO << "null container";
    }
}

void DropArea::setRootItem(Layouting::ItemBoxContainer *root)
{
    Layout::setRootItem(root);
    m_rootItem = root;
}

Layouting::ItemBoxContainer *DropArea::rootItem() const
{
    return m_rootItem;
}

QRect DropArea::rectForDrop(const WindowBeingDragged *wbd, Location location,
                            const Layouting::Item *relativeTo) const
{
    Layouting::Item item(nullptr);
    if (!wbd)
        return {};

    item.setSize(wbd->size().boundedTo(wbd->maxSize()));
    item.setMinSize(wbd->minSize());
    item.setMaxSizeHint(wbd->maxSize());

    Layouting::ItemBoxContainer *container =
        relativeTo ? relativeTo->parentBoxContainer() : m_rootItem;

    return container->suggestedDropRect(&item, relativeTo, location);
}

bool DropArea::deserialize(const LayoutSaver::MultiSplitter &l)
{
    setRootItem(new Layouting::ItemBoxContainer(view()));
    return Layout::deserialize(l);
}

int DropArea::numSideBySide_recursive(Qt::Orientation o) const
{
    return m_rootItem->numSideBySide_recursive(o);
}
