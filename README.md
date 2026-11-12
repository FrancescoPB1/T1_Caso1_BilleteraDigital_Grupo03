# Billetera Digital – Caso 1 (Servlet + JSP)

**T1 – Soluciones Web y Aplicaciones Distribuidas** · UPN
**Grupo 03**

## Integrantes

- CARLOS MANUEL BOBADILLA CALDERON
- ENZO FRANCESCO PASTOR BUSTAMANTE
- HEBERTH DANIEL AGUILAR CARRANZA
- JAVIER JHAMPIER TEJADA RODRIGUEZ
- MARCO ALEJANDRO CABALLERO RIOS

## Descripción

Aplicación web en Java (sin frameworks) que simula una billetera digital. Muestra el saldo y el historial de movimientos, y permite registrar recargas o gastos mediante un formulario HTML. La vista se genera en el servidor con JSP y los datos se mantienen en la sesión HTTP (`HttpSession`), sin base de datos.

## Funcionalidades

- Saldo inicial de **S/ 250.00** e historial vacío.
- **Recarga:** agrega un monto positivo al saldo.
- **Gasto:** descuenta un monto positivo, siempre que no supere el saldo disponible.
- Rechaza montos vacíos, no numéricos, iguales o menores que cero.
- Cada movimiento válido se agrega al inicio del historial.
- Un movimiento inválido no modifica el saldo ni el historial y muestra un mensaje de error en la misma vista.
- Patrón Post-Redirect-Get (PRG) después de un registro exitoso, para evitar reenvíos al actualizar la página.

## Tecnologías y versiones

| Tecnología | Versión |
|---|---|
| Java (JDK) | 22 (compilado con `release 17`) |
| Apache Maven | 3.10.0 |
| Apache Tomcat | 11.0.27 |
| Jakarta Servlet API | 6.1.0 |
| Jakarta JSTL | 3.0 |
| Bootstrap (CDN) | 5.3.3 |
| Editor | Visual Studio Code |


## Requisitos previos

- JDK 17 o superior, con la variable de entorno `JAVA_HOME` configurada.
- Apache Tomcat 11.
- Apache Maven 3.x.

## Pasos de ejecución

### Opción A: desplegar el `.war` incluido

1. Copiar `entregable/billetera.war` a la carpeta `webapps` de Tomcat.
2. Iniciar Tomcat:
   ```
   <TOMCAT>\bin\startup.bat
   ```
3. Abrir en el navegador: http://localhost:8080/billetera

### Opción B: compilar desde el código fuente

1. Clonar el repositorio:
   ```
   git clone https://github.com/FrancescoPB1/T1_Caso1_BilleteraDigital_Grupo03.git
   cd T1_Caso1_BilleteraDigital_Grupo03
   ```
2. Generar el `.war`:
   ```
   mvn clean package
   ```
3. Copiar `target/billetera.war` a la carpeta `webapps` de Tomcat.
4. Iniciar Tomcat y abrir http://localhost:8080/billetera

Para detener Tomcat:
```
<TOMCAT>\bin\shutdown.bat
```
