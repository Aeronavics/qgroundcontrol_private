# QGroundControl Private

## Motivations

Based on the content of qgroundcontrol_private repository, this page will describe how new features are added to the project.
The main concern here is maintainability : We want to be easily able to merge changes from the mainline into our private fork.
For that purpose the "Custom build" feature from QGC is used.

## Custom Build

qgroundcontrol_private contains a subfolder called [custom](https://github.com/Aeronavics/qgroundcontrol_private/tree/master/custom).    
In there a [custom.pri](https://github.com/Aeronavics/qgroundcontrol_private/blob/master/custom/custom.pri) file will modify the way the project is compiled. Also some major QGC classes are redefined here and new menus are added through qml files.

As an example, src/CustomPlugin.cc will redefine the common CorePlugin class with hidden pages and new menus. This way the content of the parent class CorePlugin is not altered by any changed in Aeronavics QGC.

The content of CustomPlugin.cc can be accessed [here](https://github.com/Aeronavics/qgroundcontrol_private/blob/master/custom/src/CustomPlugin.cc)

## Process

When a new feature is to be created, the developer has to 

1. Insure all the changes applied are present in the `/custom` subdirectory, this is the only way to keep this code maintainable and to keep the ability to get upgrades from the mainline.

2. Analyze QGC main interface classes (QGCCorePlugin, QGCOptions) to see if any usable property is already exposed. 
    If it's the case, the child classes (`CustomOptions` or `CustomPlugin`) needs to be modified accordingly. 

3. Create a new QML file if any menu is to be added

4. Fit as much as possible to the current architecture by defining QML interface class that expose PROPERTY and Q_INVOKABLE functions accessible from a QML ui.
