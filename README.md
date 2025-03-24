# Certify Flutter Web

![Flutter](https://img.shields.io/badge/Flutter-3.29.2-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.7.2-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![GitHub Pages](https://img.shields.io/badge/GitHub_Pages-Deployed-222222?style=for-the-badge&logo=github&logoColor=white)

Una aplicación web interactiva para preparar la certificación **Flutter Certified Application Developer (AFD-200)** con preguntas de práctica y exámenes simulados.

🚀 [Acceder a la aplicación web](https://vtorhdev.github.io/certify-flutter-web/)

## 📱 Características principales

- **Modo estudio**: Repasa preguntas por categorías con explicaciones detalladas
- **Simulador de examen**: Completa un examen de 40 preguntas en 90 minutos, similar al formato oficial
- **Información útil**: Recursos y consejos sobre el proceso de certificación AFD-200

## 🧩 Arquitectura

La aplicación está construida con principios modernos de desarrollo Flutter:

- **Bloc Pattern**: Gestión de estado limpia y testeable usando flutter_bloc
- **Navegación**: Enrutamiento declarativo con go_router para URLs limpias
- **Repositorios**: Capa de datos separada para acceder a las preguntas
- **Responsive Design**: Adaptable a diferentes tamaños de pantalla

## 🛠️ Tecnologías utilizadas

- Flutter Web (optimizado para CanvasKit)
- Patrón BLoC para la gestión de estado
- Material Design 3
- GitHub Pages para el despliegue

## 🚀 Desarrollo local

1. **Clonar el repositorio**:

   ```bash
   git clone https://github.com/tu-usuario/certify-flutter-web.git
   cd certify-flutter-web/certify_flutter_web
   ```

2. **Instalar dependencias**:

   ```bash
   flutter pub get
   ```

3. **Ejecutar en modo desarrollo**:
   ```bash
   flutter run -d chrome
   ```

## 📦 Despliegue

Para actualizar la aplicación en GitHub Pages:

```bash
# Compilar la aplicación
cd certify_flutter_web
flutter build web --base-href=/certify-flutter-web/ --release

# Copiar archivos compilados a la carpeta docs
rm -rf ../docs
mkdir -p ../docs
cp -r build/web/* ../docs/
touch ../docs/.nojekyll

# Hacer commit y push
git add ../docs
git commit -m "Actualizar aplicación web"
git push
```

## 📐 Estructura del proyecto

```
certify_flutter_web/
├── lib/
│   ├── blocs/         # Gestión de estado con BLoC
│   ├── models/        # Modelos de datos
│   ├── repositories/  # Acceso a datos
│   ├── routes/        # Configuración de navegación
│   ├── screens/       # Pantallas de la aplicación
│   ├── widgets/       # Componentes reutilizables
│   └── main.dart      # Punto de entrada
│
├── assets/           # Recursos estáticos
│   ├── data/         # Datos JSON de preguntas
│   └── images/       # Imágenes
│
└── web/              # Archivos específicos de la web
```

## 📝 Licencia

Este proyecto está bajo la Licencia GNU General Public License v3.0 (GPL-3.0). Esto significa que:

- Tienes libertad para usar, modificar y distribuir el software
- Si distribuyes versiones modificadas, debes hacerlo bajo la misma licencia GPL-3.0
- Debes incluir el código fuente o hacerlo disponible cuando distribuyas el software

Consulta el archivo LICENSE para más detalles.

---

**Nota**: Esta aplicación está diseñada con fines educativos. No está afiliada oficialmente con Google o el programa de certificación Flutter.
