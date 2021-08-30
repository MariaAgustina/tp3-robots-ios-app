# Readme

## Versiones requeridas
- iOS 14 o posteriores  

## Dependencias adicionales
- Se debe agregar al proyecto un archivo Constants.swift que contendra el accessToken para las busquedas. El mismo esta ignorado para evitar la expocision de un token en el repositorio  
- Otras dependencias se encuentran en el Podfile  


## Modo de ejecucion
- Se debera correr el comando `pod install` en la raiz del proyecto para instalar las dependencias con cocoapods. Una vez instaladas se debera correr run desde xcode  

## Modo debug
- Para correr en modo debug se debera setear la variable `shouldDebug = true en la clase DebugOptions` . Los archivos se guardaran en la carpeta Documents del dispositivo. Para verlos se puede revisar el container del device.  