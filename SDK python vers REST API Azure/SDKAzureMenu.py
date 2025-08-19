# -*- coding: utf-8 -*-
import os
from azure.identity import ClientSecretCredential
from azure.mgmt.compute import ComputeManagementClient

# =====================
# 🔑 Authentification
# =====================
tenant_id = os.environ["AZURE_TENANT_ID"]
client_id = os.environ["AZURE_CLIENT_ID"]
client_secret = os.environ["AZURE_CLIENT_SECRET"]
subscription_id = os.environ["AZURE_SUBSCRIPTION_ID"]

credential = ClientSecretCredential(tenant_id, client_id, client_secret)
client = ComputeManagementClient(credential, subscription_id)

# =====================
# 🛠 Fonctions
# =====================
def get_vm_status(resource_group, vm_name):
    """Retourne l'état (PowerState) d'une VM"""
    instance_view = client.virtual_machines.instance_view(resource_group, vm_name)
    for status in instance_view.statuses:
        if status.code.startswith("PowerState/"):
            return status.display_status
    return "Inconnu"

def lister_vms():
    print("\n=== Liste des machines virtuelles ===")
    vms = list(client.virtual_machines.list_all())
    if not vms:
        print("⚠️ Aucune VM trouvée dans cette souscription.")
    for i, vm in enumerate(vms, start=1):
        resource_group = vm.id.split("/")[4]  # Extraction du Resource Group depuis l'ID
        etat = get_vm_status(resource_group, vm.name)
        print(f"{i}. Nom: {vm.name}, Groupe: {resource_group}, Localisation: {vm.location}, Taille: {vm.hardware_profile.vm_size}, État: {etat}")
    return vms

def start_vm(resource_group, vm_name):
    print(f"\n⏳ Démarrage de la VM {vm_name}...")
    async_vm_start = client.virtual_machines.begin_start(resource_group, vm_name)
    async_vm_start.wait()
    print(f"✅ VM {vm_name} démarrée.")

def stop_vm(resource_group, vm_name):
    print(f"\n⏳ Arrêt de la VM {vm_name}...")
    async_vm_stop = client.virtual_machines.begin_deallocate(resource_group, vm_name)
    async_vm_stop.wait()
    print(f"✅ VM {vm_name} arrêtée.")

# =====================
# 📋 Menu interactif
# =====================
while True:
    print("\n=== MENU AZURE VM ===")
    print("1. Lister les VMs (avec état)")
    print("2. Démarrer une VM")
    print("3. Arrêter une VM")
    print("4. Quitter")
    
    choix = input("👉 Choisissez une option (1-4): ")

    if choix == "1":
        lister_vms()

    elif choix == "2":
        rg = input("Nom du Resource Group: ")
        vm = input("Nom de la VM à démarrer: ")
        start_vm(rg, vm)

    elif choix == "3":
        rg = input("Nom du Resource Group: ")
        vm = input("Nom de la VM à arrêter: ")
        stop_vm(rg, vm)

    elif choix == "4":
        print("👋 Bye !")
        break

    else:
        print("⚠️ Choix invalide, essayez encore.")
