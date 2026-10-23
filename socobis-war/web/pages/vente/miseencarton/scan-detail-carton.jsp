<%@ page import="vente.Carton" %>
<%@ page import="bean.CGenUtil" %><%--
  Created by IntelliJ IDEA.
  User: maroussia
  Date: 2025-05-06
  Time: 21:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String lien = (String) session.getAttribute("lien");
    String bute = "vente/miseencarton/carton-fiche.jsp";
%>
<style>
    #scanner {
        width: 100%;
        padding: 15px;
        font-size: 18px;
        border: 2px solid #ddd;
        border-radius: 4px;
        margin-bottom: 20px;
        text-align: center;
    }
    #scanner:focus {
        border-color: #007bff;
        outline: none;
    }
    .status {
        margin-top: 20px;
        font-size: 16px;
        color: #666;
    }
    .instructions {
        margin-bottom: 20px;
        color: #555;
    }
</style>
<div class="content-wrapper">
    <h1>Scanner de Code-barres</h1>
    <input type="text" id="scanner" placeholder="Scannez un code-barres" autofocus />

    <p class="status center-block" id="status">En attente du scan...</p>


    <!-- Stockage des variables JSP dans des éléments cachés pour éviter les problèmes d'échappement -->
    <input type="hidden" id="jspLien" value="<%= lien %>" />
    <input type="hidden" id="jspBut" value="<%= bute %>" />

    <script>
        console.log("Scanner initialisé");

        // Récupérer les variables depuis les éléments cachés
        // Cette méthode est plus fiable que l'insertion directe dans le JavaScript
        const lien = document.getElementById('jspLien').value;
        const bute = document.getElementById('jspBut').value;

        console.log("Lien récupéré:", lien);
        console.log("But récupéré:", bute);

        const scannerInput = document.getElementById('scanner');
        const statusElement = document.getElementById('status');

        // Focus automatique sur le champ de saisie
        window.addEventListener('load', () => {
            scannerInput.focus();
            console.log("Focus appliqué au chargement");
        });

        // Remettre le focus automatiquement
        document.addEventListener('click', () => {
            scannerInput.focus();
            console.log("Focus réappliqué après clic");
        });

        // Fonction pour traiter le scan
        function processBarcode(barcode) {
            if (!barcode) {
                console.log("Code-barres vide, annulation");
                return;
            }

            statusElement.textContent = "Redirection en cours...";
            statusElement.style.color = "#007bff";

            console.log("Traitement du code:", barcode);
            console.log("Variables utilisées - lien:", lien, "bute:", bute);
            try {
                // Création d'un formulaire pour envoyer le code-barres au serveur
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'process-barcode.jsp';
                form.style.display = 'none';

                // Ajout des champs nécessaires
                const barcodeField = document.createElement('input');
                barcodeField.type = 'hidden';
                barcodeField.name = 'barcode';
                barcodeField.value = barcode;
                form.appendChild(barcodeField);

                const lienField = document.createElement('input');
                lienField.type = 'hidden';
                lienField.name = 'lien';
                lienField.value = lien;
                form.appendChild(lienField);

                const buteField = document.createElement('input');
                buteField.type = 'hidden';
                buteField.name = 'bute';
                buteField.value = bute;
                form.appendChild(buteField);

                // Ajout du formulaire au document et soumission
                document.body.appendChild(form);
                form.submit();
            } catch (error) {
                console.error("Erreur lors de la redirection:", error);
                statusElement.textContent = "Erreur lors de la redirection. Veuillez réessayer.";
                statusElement.style.color = "red";
                scannerInput.value = "";
                scannerInput.focus();
            }
        }

        // Écouter les saisies au clavier et les scans
        scannerInput.addEventListener('keydown', function(e) {
            // Capture la touche Entrée (13) qui est souvent envoyée par les scanners
            if (e.key === 'Enter') {
                e.preventDefault();
                const barcode = this.value.trim();
                console.log("Code détecté avec Entrée:", barcode);
                processBarcode(barcode);
                this.value = "";
            }
        });

        // Gérer également les scans qui ne se terminent pas par Entrée
        scannerInput.addEventListener('input', function() {
            console.log("Saisie détectée:", this.value);
            // Certains scanners peuvent ne pas envoyer d'Entrée
            // On pourrait ajouter un timer pour gérer ces cas
        });

        // Effacer le champ si aucune redirection n'a lieu après un scan
        scannerInput.addEventListener('blur', function() {
            setTimeout(() => {
                this.value = "";
                this.focus();
                console.log("Champ effacé et focus réappliqué");
            }, 100);
        });
    </script>
</div>