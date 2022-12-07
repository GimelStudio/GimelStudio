#include "flipnode-examplesapi.h"

#include "uicomponents/view/properties.h"
// #include "gimelstudio/properties.h"

#include <QVersionNumber>

FlipNode::FlipNode() : Node {}

QVariantMap FlipNode::metaData()
{
    return {
        {"name", "Flip"},
        {"author", "Gimel Studio"},
        {"version", QVersionNumber(1, 0, 0)},
        {"category", NodeCategories.TRANSFORM},
        {"description", "Flips the orientation of the image."}
    };
}

void FlipNode::initInputProperties()
{
    ImageProperty* inputImage = new ImageProperty();
    // inputImage.setUsePropertyPanel(false);
    inputImage.setLabel("Image")
    addInputProperty("inputImage", inputImage);

    ChoiceProperty* direction = new ChoiceProperty();
    direction.setLabel("Direction");
    direction.setUseSocket(false);
    direction.setChoices(["Horizontal", "Vertical"]);
    direction.setDefaultValue("Vertical");
    addInputProperty("direction", direction);
}

void FlipNode::initOutputProperties()
{
    ImageProperty* outputImage = new ImageProperty();
    outputImage.setLabel("Output");
    // Short form for `addProperty("outputImage", outputImage, PropertyType.OUTPUT);`
    addOutputProperty("outputImage", outputImage);
}

void FlipNode::mutedEvaluation()
{
    ImageProperty* inputImage = getProperty("inputImage");
    // Each property contains a value setter and getter, *always* using the term "value"
    getProperty("outputImage")->setImage(inputImage->value());
}

void FlipNode::evaluation()
{
    ImageProperty* inputImageProp = getProperty<ImageProperty*>("inputImage");
    ChoiceProperty* directionProp = getProperty<ChoiceProperty*>("direction");

    Image* outputImage = new Image();

    switch (directionProp->value()) {
        case "Horizontal":
            // TODO: Actually flip the image
            outputImage = inputImageProp->value();
            break;
        case "Vertical":
            // TODO: Actually flip the image
            outputImage = inputImageProp->value();
            break;
        case default:
            outputImage = inputImageProp->value();
            break;
    }

    getProperty("outputImage")->setImage(outputImage);
}
