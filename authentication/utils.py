import requests

# Fonction pour envoyer un SMS via l'API Chinguisoft
def send_sms(phone_number, lang='ar'):
    # Clés et token pour l'API
    validation_key = 'YGyy486ooGx6gWGT'  # Remplacez par votre clé unique 
    token = 'ntwymjkFNEFYUGGN4Jo7Q1vEtC5RZRqY'        # Remplacez par votre token

    # URL de l'API
    url = f"https://chinguisoft.com/api/sms/validation/{validation_key}"

    # En-têtes pour la requête
    headers = {
        'Validation-token': token,
        'Content-Type': 'application/json',
    }

    # Données du payload
    data = {
        'phone': phone_number,
        'lang': lang
    }

    try:
        # Requête POST à l'API
        response = requests.post(url, headers=headers, json=data)
        response.raise_for_status()  # Vérifie les erreurs HTTP

        # Extraire l'OTP de la réponse JSON
        response_data = response.json()
        otp = response_data.get('code')  # Assurez-vous que la clé est correcte

        print(response_data)
        # Debugging: Print the OTP being sent
        print(f"OTP sent to {phone_number}: {otp}")

        return True, otp  # Retourne un succès et l'OTP
    except requests.RequestException as e:
        # Gestion des erreurs en cas d'échec
        return False, str(e)