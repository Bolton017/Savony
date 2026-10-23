<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="maintenance.ressources.DepartementMaintenance" %>
<%@ page import="maintenance.ressources.IngredientMaintenance" %>
<%@ page import="maintenance.ressources.InfosAuto" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>

<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "maintenance.ressources.InfosAuto",
                nomtable = "INFOSAUTO",
                apres = "maintenance/ressources/auto/auto-fiche.jsp",
                titre = "Saisie d'un nouveau v&eacute;hicule";

        if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update")) {
            titre = "Modification d'un v&eacute;hicule";
        }


        InfosAuto infosAuto = new InfosAuto();
        PageInsert pi = new PageInsert(infosAuto, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("idIngredient").setVisible(false);

        Liste[] liste = new Liste[2];
        TypeObjet carbu = new TypeObjet();
        carbu.setNomTable("TYPECARBURANT");
        liste[0] = new Liste("typeDeCarburant",carbu,"val","id");
        TypeObjet uc = new TypeObjet();
        uc.setNomTable("UNITECONSO");
        liste[1] = new Liste("uniteDeConsommation",uc,"val","id");
        //liste[1] = new Liste("idDevise",new caisse.Devise(),"val","id");
        //liste[1].setDefaut("AR");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("typeDeCarburant").setLibelle("Type De Carburant");
        pi.getFormu().getChamp("uniteDeConsommation").setLibelle("Unit&eacute; De Consommation");
        pi.getFormu().getChamp("huileMoteur").setLibelle("Huile Moteur");
        pi.getFormu().getChamp("datedebut").setLibelle("Date De D&eacute;but");
        pi.getFormu().getChamp("mensualite").setLibelle("Mensualit&eacute;");
        pi.getFormu().getChamp("valeurInitiale").setLibelle("Valeur Initiale");
        pi.getFormu().getChamp("puissanceFiscale").setLibelle("Puissance fiscale");
        pi.getFormu().getChamp("nombreDePortes").setLibelle("Nombre De Portes");
        pi.getFormu().getChamp("nombreDePlaces").setLibelle("Nombre De Places");
        pi.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");

        pi.getFormu().getChamp("modele").setLibelle("Mod&egrave;le");
        pi.getFormu().getChamp("description").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("datePremiereMiseEnCirculation").setLibelle("Date De Premi&egrave;re Mise En Circulation");
        pi.getFormu().getChamp("numero").setLibelle("Num&eacute;ro");
        pi.getFormu().getChamp("vin").setLibelle("VIN (Num&eacute;ro de s&eacute;rie)");
        pi.getFormu().getChamp("numeroDeParc").setLibelle("Num&eacute;ro de parc");
        pi.getFormu().getChamp("mensualite").setLibelle("Mensualit&eacute;");
        pi.preparerDataFormu();
%>
<style>
    .form-input {
        width: calc(25% - 15px);
    }
    .section-container {
        width: 100%;
        margin-bottom: 0;
    }

    .section-container h3 {
        font-family: "DM Sans";
    }
    .content-wrapper{
       min-height: 1518px !important;
    }
</style>
<div class="content-wrapper" data-skip-height-calc="true" >
    <h1> <%=titre%></h1>
    <div class="content">
        <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
            <%
                pi.getFormu().makeHtmlInsertTabIndex();
                out.println(pi.getFormu().getHtmlInsert());
                out.println(pi.getHtmlAddOnPopup());
            %>
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%=apres%>">
            <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
            <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
        </form>
    </div>

</div>
<script>
    /**
     * Réorganisation du formulaire véhicule avec sections
     * Version simplifiée sans modification des colonnes
     */

    // Attendre que le DOM soit complètement chargé
    window.addEventListener('DOMContentLoaded', function() {
        console.log('🚀 Démarrage de la réorganisation du formulaire...');
        reorganiserFormulaire();
    });

    function reorganiserFormulaire() {
        // Trouver le container
        const container = document.querySelector('.input-container');

        if (!container) {
            console.error('❌ Container .input-container non trouvé');
            return;
        }

        console.log('✅ Container trouvé');

        // Configuration des sections
        const sections = [
            {
                titre: 'Identifiant',
                champs: ['description', 'numeroDeParc', 'modele']
            },
            {
                titre: 'Immatriculation',
                champs: ['datePremiereMiseEnCirculation', 'immatriculation', 'note']
            },
            {
                titre: 'Carte Carburant',
                champs: ['fournisseur', 'numero', 'volume', 'montant', 'type']
            },
            {
                titre: 'Modèle',
                champs: ['vin', 'marque', 'annee', 'nombreDePlaces', 'nombreDePortes', 'puissanceFiscale']
            },
            {
                titre: 'Location longue durée',
                champs: ['bailleur', 'valeurInitiale', 'datedebut', 'mensualite']
            },
            {
                titre: 'Achat',
                champs: ['vendeur', 'prix']
            },
            {
                titre: 'Référence',
                champs: ['pneus', 'batterie', 'huileMoteur']
            },
            {
                titre: 'Carburant',
                champs: ['typeDeCarburant', 'consommation', 'uniteDeConsommation']
            }
        ];

        // Récupérer tous les .form-input existants
        const formInputs = container.querySelectorAll('.form-input');
        console.log(`📋 ${formInputs.length} champs .form-input trouvés`);

        // Créer une map des champs par nom
        const champsMap = new Map();

        formInputs.forEach((formInputDiv, index) => {
            const input = formInputDiv.querySelector('input, select');
            if (input) {
                const name = input.getAttribute('name') || input.getAttribute('id');
                if (name) {
                    champsMap.set(name, formInputDiv);
                    console.log(`  ✓ ${index + 1}. ${name}`);
                }
            }
        });

        console.log(`📦 ${champsMap.size} champs mappés`);

        // Sauvegarder les boutons avant de vider
        const boxFooter = container.parentElement.querySelector('.box-footer');

        // Créer le nouveau contenu
        const fragment = document.createDocumentFragment();

        sections.forEach(section => {
            // Créer la section
            const sectionDiv = document.createElement('div');
            sectionDiv.className = 'section-container';
            sectionDiv.style.marginBottom = '2rem';

            // Créer le titre
            const h3 = document.createElement('h3');
            h3.style.cssText = 'font-size: 16px; font-weight: 600; margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 1px solid var(--Border); color: #374151;';
            h3.textContent = section.titre;
            sectionDiv.appendChild(h3);

            // Créer un input-container pour les champs de cette section
            const inputContainer = document.createElement('div');
            inputContainer.className = 'input-container';

            // Ajouter les champs dans l'input-container
            let count = 0;
            section.champs.forEach(champName => {
                const formInput = champsMap.get(champName);
                if (formInput) {
                    // Cloner le champ pour l'ajouter à la section
                    const clone = formInput.cloneNode(true);
                    inputContainer.appendChild(clone);
                    count++;
                } else {
                    console.warn(`⚠️  Champ "${champName}" non trouvé`);
                }
            });

            // Ajouter l'input-container à la section
            sectionDiv.appendChild(inputContainer);

            if (count > 0) {
                fragment.appendChild(sectionDiv);
                console.log(`✅ Section "${section.titre}" créée avec ${count} champs dans input-container`);
            }
        });

        // Vider et remplacer le contenu
        container.innerHTML = '';
        container.appendChild(fragment);

        // Remettre les boutons
        if (boxFooter) {
            container.parentElement.appendChild(boxFooter);
            console.log('✅ Boutons réinsérés');
        }

        console.log('🎉 Réorganisation terminée avec succès !');
    }

    // Fonction de diagnostic
    function diagnostiquerFormulaire() {
        console.log('\n=== DIAGNOSTIC ===');
        const container = document.querySelector('.input-container');

        if (!container) {
            console.error('❌ .input-container introuvable');
            return;
        }

        const formInputs = container.querySelectorAll('.form-input');
        console.log(`Nombre de .form-input: ${formInputs.length}\n`);

        formInputs.forEach((div, i) => {
            const input = div.querySelector('input, select');
            if (input) {
                const name = input.name || input.id || 'sans nom';
                const type = input.tagName.toLowerCase();
                console.log(`${i + 1}. [${type}] name="${name}"`);
            }
        });

        console.log('=================\n');
    }

    // Exposer les fonctions globalement pour tests manuels
    window.reorganiserFormulaire = reorganiserFormulaire;
    window.diagnostiquerFormulaire = diagnostiquerFormulaire;
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>
