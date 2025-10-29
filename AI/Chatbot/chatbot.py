import openai
import gradio as gr
 
# 🔑 Clé API OpenAI
openai.api_key = "TON_API_KEY_ICI"
 
# Fonction pour gérer la conversation
def chat_with_gpt(user_message, chat_history):
    """
    user_message : texte entré par l'utilisateur
    chat_history : liste de messages pour garder le contexte
    """
    if chat_history is None:
        chat_history = []
 
    # Ajouter le message utilisateur
    chat_history.append({"role": "user", "content": user_message})
 
    # Appel API ChatGPT
    response = openai.ChatCompletion.create(
        model="gpt-4",  # ou "gpt-3.5-turbo"
        messages=chat_history,
        temperature=0.7,
        max_tokens=500
    )
 
    reply = response['choices'][0]['message']['content']
 
    # Ajouter la réponse à l'historique
    chat_history.append({"role": "assistant", "content": reply})
 
    # Retourne le message à afficher et l'historique pour le contexte
    return reply, chat_history
 
# --- Interface Gradio ---
iface = gr.Interface(
    fn=chat_with_gpt,
    inputs=["text", "state"],   # Texte utilisateur + historique
    outputs=["text", "state"],  # Réponse + historique
    title="ChatGPT Web Chatbot",
    description="Chatbot interactif avec interface web basé sur OpenAI ChatGPT.",
    allow_flagging="never"
)
 
iface.launch()