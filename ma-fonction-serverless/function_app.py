import azure.functions as func
import pymssql
import json
import logging
import os

app = func.FunctionApp()

# 🔐 Variables d'environnement pour la base de données
DB_SERVER = os.environ.get("DB_SERVER")
DB_DATABASE = os.environ.get("DB_DATABASE")
DB_USERNAME = os.environ.get("DB_USERNAME")
DB_PASSWORD = os.environ.get("DB_PASSWORD")

# 🧩 Fonction utilitaire pour la connexion SQL
def get_db_connection():
    if not all([DB_SERVER, DB_DATABASE, DB_USERNAME, DB_PASSWORD]):
        missing = [v for v in ["DB_SERVER", "DB_DATABASE", "DB_USERNAME", "DB_PASSWORD"]
                   if not os.environ.get(v)]
        raise Exception(f"Configuration manquante : {missing}")
    return pymssql.connect(
        server=DB_SERVER,
        user=DB_USERNAME,
        password=DB_PASSWORD,
        database=DB_DATABASE
    )

# 🔵 INSÉRER UTILISATEUR
@app.route(route="InsererUtilisateur", auth_level=func.AuthLevel.ANONYMOUS, methods=["POST"])
def InsererUtilisateur(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Azure Function "InsererUtilisateur" déclenchée.')

    # Vérification du token Azure AD (header Authorization)
    auth_header = req.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return func.HttpResponse("Unauthorized", status_code=401)

    try:
        req_body = req.get_json()
        nom = req_body.get('nom')
        email = req_body.get('email')

        if not nom or not email:
            return func.HttpResponse(
                json.dumps({"error": "Les champs 'nom' et 'email' sont requis."}),
                status_code=400,
                mimetype="application/json"
            )

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    "INSERT INTO Utilisateurs (Nom, Email) VALUES (%s, %s)",
                    (nom, email)
                )
                conn.commit()

        return func.HttpResponse(
            json.dumps({"message": f"Utilisateur {nom} enregistré avec succès !"}),
            status_code=200,
            mimetype="application/json"
        )

    except pymssql.DatabaseError as db_err:
        logging.error(f"Erreur SQL : {db_err}")
        return func.HttpResponse(
            json.dumps({"error": f"Erreur SQL : {db_err}"}),
            status_code=500,
            mimetype="application/json"
        )
    except Exception as e:
        logging.exception("Erreur inattendue.")
        return func.HttpResponse(
            json.dumps({"error": str(e)}),
            status_code=500,
            mimetype="application/json"
        )
