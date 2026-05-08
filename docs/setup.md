# Setup detallado

Esta guía te lleva paso a paso desde cero hasta tener el workflow corriendo en tu propia instancia de n8n.

## Requisitos

- n8n 2.x (local con `npm install -g n8n` o n8n Cloud).
- Cuenta de Google con acceso a Google Sheets y Gmail.
- Acceso a [Google Cloud Console](https://console.cloud.google.com/).

## 1. Crear la hoja de Google Sheets

1. Crear una hoja nueva en Google Sheets.
2. En la primera fila, agregar estos encabezados (celdas A1 a E1):

   | A1 | B1 | C1 | D1 | E1 |
   |---|---|---|---|---|
   | timestamp | name | email | phone | message |

3. Guardar el **Spreadsheet ID** que aparece en la URL (la cadena entre `/d/` y `/edit`).
4. **Recomendado:** seleccionar la columna D (phone) → Format → Number → Plain text. Esto evita que números con `+` sean interpretados como fórmulas.

## 2. Configurar Google Cloud OAuth

1. Ir a [Google Cloud Console](https://console.cloud.google.com/) y crear un proyecto nuevo (o usar uno existente).
2. **Habilitar APIs:**
   - APIs & Services → Library.
   - Buscar y habilitar: **Google Sheets API**, **Google Drive API**, **Gmail API**.
3. **OAuth Consent Screen:**
   - APIs & Services → OAuth consent screen.
   - User type: **External**.
   - App name: el que prefieras (ej. `Lead Capture n8n`).
   - User support email y Developer contact: tu correo.
   - Scopes: dejar vacío (n8n agrega los necesarios).
   - Test users: agregar el correo de Google que vas a autenticar.
4. **Credentials:**
   - APIs & Services → Credentials → + Create Credentials → OAuth Client ID.
   - Application type: **Web application**.
   - Authorized redirect URIs: `http://localhost:5678/rest/oauth2-credential/callback` (cambiar el host si tu n8n está en otra parte).
   - Crear y copiar **Client ID** y **Client Secret**.

## 3. Importar el workflow en n8n

1. En n8n, ir a Workflows → menú (3 puntos) → **Import from File**.
2. Seleccionar [`workflow.json`](../workflow.json).
3. El workflow se importa con todos los nodos pero los placeholders de credenciales y Spreadsheet ID requieren completarse.

## 4. Conectar credenciales en n8n

### Google Sheets:
1. Abrir el nodo **Append row in sheet**.
2. En "Credential to connect with" → **Create New Credential** → tipo `Google Sheets OAuth2 API`.
3. Pegar Client ID y Client Secret.
4. Click **Sign in with Google** → autorizar.
5. Asignar la credencial al nodo.

### Gmail:
1. Abrir el nodo **Send a message**.
2. En "Credential to connect with" → **Create New Credential** → tipo `Gmail OAuth2 API`.
3. Reutilizar el mismo Client ID y Client Secret (sirven para ambas APIs).
4. Click **Sign in with Google** → autorizar permisos de Gmail.
5. Asignar la credencial al nodo.

## 5. Configurar el Spreadsheet ID

1. Abrir el nodo **Append row in sheet**.
2. En **Document**, seleccionar tu hoja desde el dropdown (ya conectada por la credencial), o pegar manualmente el Spreadsheet ID reemplazando `YOUR_SPREADSHEET_ID`.
3. En **Sheet**, seleccionar la hoja interna (típicamente "Sheet1" o "Hoja 1").

## 6. Probar el flujo

### En modo test:
1. En el nodo Webhook, click **Listen for test event**.
2. Mandar un POST de prueba (ver [`examples/curl-test.sh`](../examples/curl-test.sh)).
3. Verificar que los 5 nodos se pongan verdes.
4. Confirmar que apareció una fila nueva en Sheets y un correo en la bandeja del destinatario.

### Activar producción:
1. Guardar el workflow (`Cmd+S`).
2. Toggle **Inactive → Active** arriba a la derecha.
3. La URL de producción es `http://<tu-n8n-host>:5678/webhook/lead-capture`.
