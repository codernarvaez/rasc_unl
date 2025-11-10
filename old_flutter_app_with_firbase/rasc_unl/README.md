🏃‍♂️ #RASC_UNL

Road Athletics Stopwatch for Competitions
Sistema de cronometraje inteligente para competencias atléticas desarrollado en la Universidad Nacional de Loja.

📘 Descripción General

RASC_UNL (Road Athletics Stopwatch for Competitions) es una aplicación diseñada para gestionar y registrar cronometrajes de competencias atléticas en carretera y pista, integrando hardware y software de bajo costo.
El sistema permite la captura, procesamiento y almacenamiento en tiempo real de los datos de carrera, ofreciendo una herramienta precisa, confiable y adaptable para eventos deportivos universitarios y comunitarios.

Este proyecto se desarrolla en el marco del programa de Vinculación con la Sociedad de la Carrera de Computación – Universidad Nacional de Loja (UNL), como una propuesta tecnológica para digitalizar los procesos deportivos y mejorar la experiencia de gestión en competencias.

🎯 Objetivos del Proyecto

🧠 Desarrollar un sistema inteligente de cronometraje deportivo utilizando tecnologías abiertas y accesibles.

⚙️ Integrar sensores de tiempo y módulos IoT con una plataforma web de registro y visualización.

🏅 Optimizar la gestión de resultados y clasificaciones de atletas mediante herramientas de análisis y reportes automatizados.

🌐 Contribuir a la modernización tecnológica del deporte universitario y comunitario en la ciudad de Loja.

🧩 Características Principales
Tipo	Descripción
🕒 Cronometraje automático	Medición precisa de tiempos de llegada y salida por chip RFID o sensores IR.
📡 Sincronización IoT	Comunicación entre dispositivos a través de MQTT o API REST.
🖥️ Panel web	Interfaz para registrar atletas, eventos y resultados en tiempo real.
📊 Visualización de datos	Gráficas, tiempos promedio y clasificación automática.
🔒 Seguridad	Acceso autenticado y gestión de usuarios.
🧱 Arquitectura modular	Escalable, portable y adaptable a diferentes tipos de competencias.
🧠 Arquitectura del Sistema
[ Sensor / RFID / IR ]
↓
[ Microcontrolador IoT (ESP32) ]
↓ MQTT / HTTP
[ Servidor Backend API ]
↓
[ Base de Datos ]
↓
[ Frontend Web / Dashboard ]

🧰 Tecnologías Utilizadas
Componente	Tecnología / Herramienta
Backend	Python (FastAPI / Flask)
Frontend	React / Next.js
Hardware	ESP32, sensores IR, módulos RFID
Base de Datos	PostgreSQL / MongoDB
Comunicación	MQTT, HTTP REST
Infraestructura	Docker / Kubernetes (despliegue local y nube)
📦 Instalación y Configuración
🔧 Requisitos previos

Python 3.10+

Node.js 18+

Docker (opcional para despliegue)

Cuenta o servidor local para API

🧩 Pasos de instalación
# 1. Clonar el repositorio
git clone https://github.com/tuusuario/rasc_unl.git

# 2. Ingresar al directorio del proyecto
cd rasc_unl

# 3. Instalar dependencias del backend
pip install -r requirements.txt

# 4. Instalar dependencias del frontend
cd frontend && npm install

# 5. Ejecutar el servidor local
npm run dev

🚀 Uso del Sistema

Registrar una competencia y los atletas participantes.

Conectar los dispositivos de cronometraje al servidor IoT.

Iniciar la carrera desde el panel web.

Visualizar los tiempos en vivo y exportar reportes en formato PDF o CSV.

🧑‍💻 Equipo de Desarrollo

Ing. Cristian Ramiro Narváez Guillén – Docente Asesor

Estudiantes de la Carrera de Computación – UNL

Colaboradores: Área de Deportes UNL y Proyecto de Vinculación 2025

📚 Licencia

Este proyecto se distribuye bajo la Licencia MIT, lo que permite su libre uso, modificación y distribución con fines educativos y sociales, citando su autoría original.

💬 Cita sugerida

Universidad Nacional de Loja (2025). RASC_UNL – Road Athletics Stopwatch for Competitions. Carrera de Computación, Facultad de Energía, las Industrias y los Recursos Naturales No Renovables.
