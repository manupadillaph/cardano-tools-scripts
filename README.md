
*******************************************  

## **Haskell Validator and Policie Scripts**


### **Cardano Developments Tools** 

*******************************************  

*** README Deprecated ***
 
*******************************************  

### Utilización

*******************************************  

Lo primero que se debe hacer es setear las variables de entorno. 

Para ello hay que editar el archivo: `scripts/env/write-env-list-testnet.sh`  
O para mainnet: `scripts/env/write-env-list-mainnet.sh`  
Y este otro: `scripts/env/write-env-list.sh`  

Una vez editados esos arhivos se puede ejecutar para setear las variables en esta sesion:
```
source "scripts/env/write-env-list-testnet.sh"
```

Y luego se puede ejecutar el main script desde caulquier directorio con: 
```
bash $MAIN
```

******************************************* 

### Requisitos

*******************************************  
  
Para poder usar todas las opciones de los scripts se necesitan las siguientes herramientas:  
  
- Se necesita el nodo de cardano.  
- Se necesitan las herramientas de Plutus Apps.  
- Se necesita instalar Nix y abrir el shell en Plutus Apps. 
- Se necesita el servidor de wallets de cardano.  

Las direcciones donde se instalan estas herramientas deben estar configuradas en el archivo `scripts/env/write-env-list.sh`     

*******************************************  

<br>
Es importante desde que carpeta se ejecutan, pues van a querer guardar archivos y estos se guardan en un directorio relativo al path desde donde se estan ejecutando.  

La carpeta donde voy a querer guardar los archivos es: `scripts/files/` 

  
Hay una carpeta para cada tipo de arhivo exportado:    

- `scripts/files/config`: archivos de configuracion del protocolo necesarios para crear transacciones.  
- `scripts/files/datums`: archivos json de los datums.    
- `scripts/files/redeemers`: archivos json de los redeemers. 
- `scripts/files/transacciones`: archivos creados al hacer transacciones. Se crea el archivo .body primero y luego el .signed.
- `scripts/files/validators`: archivos .plutus, .hash y .addr de los validatores.    
- `scripts/files/wallets`: archivos .vkey, .skey, .pkh, .json, de cada wallet.

Si ejecuto `cabal exec deploy-manual` desde la raiz del repositorio, elijo la opción: `1: write script plutus cbor`, debo poner cuando me pide que ingrese path el siguiente: `scripts/files/validators`.  
  
Pero si ejecuto `cabal exec deploy-auto` desde la carpeta `scripts`, el path correcto será el siguiente: `files/validators`. Así es como se utiliza dentro del script `main.sh`  

Dentro de la carpeta `scripts` se encuentra el archivo `main.sh`. 
Es una aplicación de linea de comandos para interactuar con las wallets y los contratos.
  
Ejecutar con:
> cd scripts
> bash ./main.sh

La aplicación guardará todos los archivos creados en la carpeta `scripts/file`

Si se desea poder crear nuevas wallets por medio de esta aplicación se deben tener NODO y WALLET SERVER corriendo en la pc y configurado las siguientes variables de entorno:    

```
CARDANO_WALLET=ruta al server de WALLLET    
CARDANO_NODE=ruta al NODO   
TESTNET_MAGIC  
```

Y crear la carpeta `$CARDANO_WALLET/wallets  `

Para ver como correr NODO y WALLET y configurarlos para que funcionen con esta apliación referirse README del repositorio: `cardano-falcon-stakepol-devs-scripts`    


*******************************************  
### Solución de problemas

*******************************************  

- Problemas de permisos con git, ejecutar: `git config --global --add safe.directory /home/manuelpadilla/source/Plutus-Devs/cardano-devs-plutus`


