# n8n Lead Capture Pipeline

Workflow listo para producción que **captura leads vía webhook**, los registra en Google Sheets y envía un correo automático de bienvenida al lead.

Resuelve un caso típico de automatización: un sitio web tiene un formulario de contacto y necesita que cada submisión quede registrada como CRM básico, que el lead reciba confirmación inmediata, y que el sitio reciba una respuesta estructurada.

## Diagrama del flujo

```
┌─────────┐    ┌──────────────┐    ┌──────────────────┐    ┌──────────────┐    ┌────────────────────┐
│ Webhook │ →  │ Edit Fields  │ →  │ Google Sheets    │ →  │ Gmail        │ →  │ Respond to Webhook │
│ (POST)  │    │ (normaliza)  │    │ (append row)     │    │ (welcome)    │    │ (status: ok)       │
└─────────┘    └──────────────┘    └──────────────────┘    └──────────────┘    └────────────────────┘
```

## Stack

- **n8n** 2.x (self-hosted o cloud)
- **Google Sheets API** + **Gmail API** (gratis, OAuth 2.0)
- **HTTP webhook** como entrada

## Casos de uso

- Formularios de contacto de sitios web (WordPress, Webflow, Tilda, sitios estáticos).
- Capturas desde landing pages.
- Integración con cualquier sistema externo que pueda hacer POST con JSON.

## Estructura del payload de entrada

El webhook espera un POST con `Content-Type: application/json` y este body:

```json
{
  "name": "Maria Lopez",
  "email": "maria@example.com",
  "phone": "+57 300 1234567",
  "message": "Quisiera información sobre sus servicios"
}
```

Ver [`examples/sample-payload.json`](examples/sample-payload.json) y [`examples/curl-test.sh`](examples/curl-test.sh) para probar.

## Estructura de la hoja de Google Sheets

El workflow espera una hoja con esta primera fila como encabezados:

| timestamp | name | email | phone | message |
|---|---|---|---|---|

## Setup

1. Importar [`workflow.json`](workflow.json) en tu instancia de n8n.
2. Reemplazar `YOUR_SPREADSHEET_ID` por el ID de tu hoja de Google Sheets (lo encuentras en la URL de la hoja).
3. Crear las credenciales OAuth2 de Google Sheets y Gmail en n8n y vincularlas a los nodos correspondientes.
4. Activar el workflow.

Pasos detallados con capturas en [`docs/setup.md`](docs/setup.md).

## Salida

- **Google Sheets:** una fila nueva por cada lead recibido.
- **Correo de bienvenida:** HTML personalizado al lead con su nombre.
- **Respuesta HTTP al webhook:** `{"status":"ok","message":"Lead recibido correctamente"}`.

## Licencia

[MIT](LICENSE).
