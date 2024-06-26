# Código AI Triage

## Descripción
Código AI Triage es una aplicación interactiva de triaje asistida por un chatbot que utiliza el modelo GPT-4 de OpenAI para evaluar rápidamente la gravedad de las afecciones médicas reportadas por los pacientes. El sistema facilita la priorización eficaz de casos en entornos de urgencias médicas.

## Características
- **Triage Asistido por IA**: Usa la tecnología de GPT-4 para clasificar a los pacientes basándose en la urgencia.
- **Interfaz Intuitiva**: La aplicación Flutter ofrece una interfaz de usuario amigable para la interacción con el chatbot.
- **Backend Robusto**: Un servidor FastAPI gestiona la lógica de backend y se comunica con la API de Azure OpenAI.

## Requisitos Previos
- Python 3.8 o superior
- Flutter 2.0 o superior
- Acceso a Azure OpenAI API

## Configuración del Entorno
Describe los pasos para configurar el entorno de desarrollo, como la instalación de dependencias de Python, configuración de variables de entorno, y cómo instalar Flutter y las dependencias de Dart.

```bash
pip install -r requirements.txt
export AZURE_OPENAI_ENDPOINT='tu_endpoint'
export AZURE_OPENAI_API_KEY='tu_api_key'
flutter pub get
```

## Ejecución de la Aplicación
Instrucciones detalladas sobre cómo ejecutar la aplicación, tanto para el backend como para el frontend.

```bash
# Para ejecutar el servidor FastAPI
uvicorn main:app --reload

# Para ejecutar la aplicación Flutter
flutter run
```

## Estructura del Proyecto
Una explicación de la estructura de archivos y directorios de alto nivel.

```
/codigo_ai_triage
|-- /android
|-- /ios
|-- /lib
|   |-- /models
|   |-- /services
|   |-- /views
|   |-- /widgets
|   |-- main.dart
|-- /test
|-- pubspec.yaml
|-- /backend
    |-- main.py
    |-- /venv
    |-- requirements.txt
```

## Pruebas
Explica cómo ejecutar las pruebas unitarias y de integración.

```bash
# Para pruebas de backend
pytest

# Para pruebas de Flutter
flutter test
```

## Contribuir
Guías para contribuir al proyecto, incluyendo estándares de código, cómo enviar pull requests y otros procesos relevantes.

## Licencia
Detalles sobre la licencia del proyecto. Por ejemplo:

Este proyecto está licenciado bajo la Licencia MIT - vea el archivo [LICENSE](LICENSE) para más detalles.

## Contacto
Información sobre cómo contactar al equipo del proyecto o al mantenedor.

## Agradecimientos