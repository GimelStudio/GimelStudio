# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------

import os.path
import wx
from gsnodegraph import NodeBase as NodeView

import gimelstudio.constants as const
from gimelstudio.utils import ResizeKeepAspectRatio, ConvertImageToWx
from gimelstudio.core import EvalInfo, Image


class Node(NodeView):
    def __init__(self, nodegraph, id):
        NodeView.__init__(self, nodegraph, id)
        self.nodegraph = nodegraph
        self.id = id
        self.properties = {}
        self.outputs = {}

        self.cache = {}
        self.cache_enabled = False
        self.edited_flag = False
        self.shader_cache = None
        self.shader_cache_enabled = True

        self.NodeInitProps()
        self.NodeInitOutputs()

    def _WidgetEventHook(self, idname, value, render):
        """ Internal dispatcher method for the Property widget
        callback event hook method, `WidgetEventHook`.

        Please do not override.
        """
        self.SetEditedFlag(True)
        if render == True:
            self.NodeWidgetEventHook(idname, value)
            self.nodegraph.parent.parent.Render()

    @property
    def NodeMeta(self):
        """ Override property for node meta information. """
        meta_info = {
            "label": "...",
            "author": "N/A",
            "version": (0, 0, 1),
            "category": "DEFAULT",
            "description": "...",
        }
        return meta_info

    @property
    def GLSLRenderer(self):
        return self.nodegraph.GLSLRenderer

    def GetLabel(self):
        return self.NodeMeta["label"]

    def GetAuthor(self):
        return self.NodeMeta["author"]

    def GetVersion(self):
        return self.NodeMeta["version"]

    def GetCategory(self):
        return self.NodeMeta["category"]

    def GetDescription(self):
        return self.NodeMeta["description"]

    def IsOutputNode(self):
        return False

    def IsNodeCacheEnabled(self):
        return self.cache_enabled

    def AddProperty(self, prop):
        self.properties[prop.idname] = prop
        return self.properties

    def EditProperty(self, idname, value, render=True):
        prop = self.properties[idname]
        prop.SetValue(value, render)
        return prop

    # def EditParameter(self, idname, value):
    #     #param = self.properties[idname]
    #     #param.binding = value
    #     param = self.parameters[idname]
    #     param.SetBinding(value)
    #     #self.RemoveFromCache(idname)
    #     return param

    def EditConnection(self, name, binding, socket):
        print("[DEBUG] Make connection: ", binding, socket)
        if binding is not None:
            binding = (binding, socket)
        self.properties[name].binding = binding

    def SetEditedFlag(self, edited=True):
        self.edited_flag = edited

    def GetEditedFlag(self):
        return self.edited_flag

    def NodeInitProps(self):
        """ Define node properties for the node. These will translate into widgets for editing the property in the Node Properties Panel if the Property is not hidden with ``visible=False``.

        Subclasses of the ``Property`` object such as ``LabelProp``, etc. are to be added with the ``NodeAddProp`` method.

        >>> self.lbl_prop = api.LabelProp(idname="Example", default="", label="Example label:", visible=True)
        >>> self.NodeAddProp(self.lbl_prop)
        """
        pass

    def NodeInitOutputs(self):
        pass

    def NodeAddProp(self, prop):
        """ Add a property to this node.

        :param prop: instance of `PropertyField` property class
        :returns: dictionary of the current properties
        """
        prop.SetWidgetEventHook(self._WidgetEventHook)
        return self.AddProperty(prop)

    def NodeEditProp(self, idname, value, render=True):
        """ Edit a property of this node.

        :param name: name of the property
        :param value: new value of the property
        :param render: if set to ``False``, the node graph will not render after the property is edited as it usually would
        :returns: the current property value
        """
        return self.EditProperty(idname, value, render)

    def NodePanelUI(self, parent, sizer):
        """ Create the Node property widgets for the Node Property Panel. Please do not override unless you know what you're doing.
        """
        for prop in self.properties:
            prop_obj = self.properties[prop]
            if prop_obj.GetIsVisible() is True:
                prop_obj.CreateUI(parent, sizer)

    def NodeUpdateThumb(self, image):
        if self.IsExpanded():
            image = image.GetImage()
            img = ResizeKeepAspectRatio(image, (134, image.shape[1]))
            self.SetThumbnail(ConvertImageToWx(img))
            self.nodegraph.UpdateNodeGraph()

    def NodeEvalSelf(self):
        return self.NodeEvaluation(EvalInfo(self))

    def NodeEvaluation(self, eval_info):
        return None

    def NodeWidgetEventHook(self, idname, value):
        """ Property widget callback event hook. This method is called after the property widget has returned the new value. It is useful for updating the node itself or other node properties as a result of a change in the value of the property.

        **Keep in mind that this is only called after a property is edited by the user. If you are looking for more flexibility, you should look into creating your own Property.**

        :prop idname: idname of the property which was updated and is calling this method
        :prop value: updated value of the property
        """
        pass

    def NodeDndEventHook(self):
        pass

    def ClearCache(self):
        self.cache = {}

    def RemoveFromCache(self, name):
        cached = self.IsInCache(name)
        if cached is True and self.IsNodeCacheEnabled() is True:
            del self.cache[name]

    def IsInCache(self, name):
        try:
            self.cache[name]
            return True
        except KeyError:
            return False

    def EvalProperty(self, eval_info, name):
        cached = self.IsInCache(name)

        # Basic node cache implementation
        if self.IsNodeCacheEnabled() == True:
            if self.GetEditedFlag() == True and cached == True:
                value = self.cache[name]
                self.SetEditedFlag(False)
                # print("Used Cache: ", name)
            else:
                value = eval_info.EvaluateProperty(name)
                self.cache[name] = value
                self.SetEditedFlag(False)
                # print("Evaluated: ", name)
        else:
            value = eval_info.EvaluateProperty(name)

        return value

    @property
    def EvaluateNode(self):
        """ Internal method. Please do not override. """
        if self.IsMuted():
            return self.MutedNodeEvaluation
        return self.NodeEvaluation
 
    def EvalMutedNode(self, eval_info):
        try:
            image = self.EvalProperty(eval_info, "in_image").GetImage()
        except:
            image = self.EvalProperty(eval_info, "in_image_2").GetImage()
        render_image = Image()
        render_image.SetAsImage(image)
        self.NodeUpdateThumb(render_image)
        
        # TODO: support multi-outputs
        return {
            "image": render_image
        }

    def RenderGLSL(self, path, props, image, image2=None):
        if self.shader_cache_enabled == True:
            if self.shader_cache == None:
                self.shader_cache = self.LoadGLSL(path)
            shader = self.shader_cache
        else:
            shader = self.LoadGLSL(path)
        self.GLSLRenderer.Render(shader, props, image, image2)
        return self.GLSLRenderer.ReadNumpy()

    def LoadGLSL(self, path):
        file_path = os.path.expanduser(os.path.expandvars(path))
        shader_path = os.path.join(const.APP_DIR, file_path)
        return self.GLSLRenderer.LoadGLSLFile(shader_path)

    def RefreshNodeGraph(self):
        """ Force a refresh of the Node Graph panel. """
        self.nodegraph.UpdateNodeGraph()

    def RefreshPropertyPanel(self):
        """ Force a refresh of the Node Properties panel. """
        wx.CallAfter(self.nodegraph.parent.PropertiesPanel.UpdatePanelContents, self)
