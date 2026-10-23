<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="user.UserEJB" %>
<%@ page import="declaration.LiaisonCodeImpot" %>
<%@ page import="affichage.Champ" %>
<%@ page import="mg.cnaps.compta.ComptaCompte" %>
<%@ page import="declaration.ImprimerDeclaration" %>
<%@ page import="declaration.LiaisonCodeImpotSaisie" %>
<%@ page import="affichage.Liste" %>

<% try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    int taille = 10;

    LiaisonCodeImpotSaisie fille = new LiaisonCodeImpotSaisie();
    fille.setNomTable("LIAISONCODESAISIE");

    PageInsertMultiple pi = new PageInsertMultiple(fille, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));
    pi.setTitre("Saisie liaison compte - code impot");

    // Champs parent : on rend visible l'id code imp f4t pour saisie + autocomplete
    pi.getFormu().getChamp("idcodeimpot").setVisible(false);

    pi.getFormu().getChamp("idcompte").setVisible(false);

    // Champs du tableau enfant : libelle et selection via page appel avec filtre
    pi.getFormufle().getChamp("idcompte_0").setLibelle("Compte");
    pi.getFormufle().getChamp("idcodeimpot_0").setLibelle("Code");
    pi.getFormufle().getChamp("valeur_0").setLibelle("Libell&eacute;");
    pi.getFormufle().getChamp("formule_0").setLibelle("Formule");
    pi.getFormufle().getChamp("taxable_0").setLibelle("Taxable");
//    Champ.setAutocomplete(pi.getFormufle().getChampFille("idcodeimpot"), "declaration.ChoixCodeImpotSaisie", "id", "CODEIMPOTS", "id", "idcodeimpot", "val", "val", "");
    Champ.setAutocomplete(pi.getFormufle().getChampFille("idcodeimpot"),"numero","id","IMPRIMEDECLARATION","");
    //Champ.setAutocomplete(pi.getFormufle().getChampFille("idcompte"),"libelle","compte","COMPTA_COMPTE","");

    Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idcompte"),
            "mg.cnaps.compta.ComptaCompte","compte","COMPTA_COMPTE");

    String acte = "insertFilleSeul";
    String acteupdate = request.getParameter("acte");
    String[] colOrdre = {"idcodeimpot","idcompte", "valeur","formule","taxable"};
    if(acteupdate!=null && !acteupdate.trim().isEmpty() && acteupdate.equalsIgnoreCase("update")){
         colOrdre = new String[]{"id","idcodeimpot","idcompte", "valeur","formule","taxable"};
        for (int i = 0; i < pi.getNombreLigne(); i++) {
            pi.getFormufle().getChamp("id_"+i).setAutre("readonly");
        }
        acte = "updateMultiple";
    }
    pi.getFormufle().setColOrdre(colOrdre);

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=declaration/apresMultipleResultat.jsp" method="post" >
        <%
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="<%=acte%>">
        <input name="bute" type="hidden" id="bute" value="declaration/liste-codeimpot-compte.jsp">
        <input name="classe" type="hidden" id="classe" value="declaration.LiaisonCodeImpotSaisie">
        <input name="classefille" type="hidden" id="classefille" value="declaration.LiaisonCodeImpotSaisie">
        <input name="nomtable" type="hidden" id="nomtable" value="LIAISONCODEIMPOT">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <!-- Le champ idcodeimpot est déjà porté par le formulaire généré (visible/autocomplete) -->
    </form>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function(){
        var total = <%=taille%>;

        // Générer les selects formule et taxable et remplacer les inputs existants
        for(var i = 0; i < total; i++){
            // Remplacer formule_i
            var formuleInput = document.getElementById('formule_' + i);
            if(formuleInput){
                var selectFormule = document.createElement('select');
                selectFormule.id = 'formule_' + i;
                selectFormule.name = 'formule_' + i;
                selectFormule.className = 'form-control';

                var optionsFormule = [
                    {value: 'credit', text: 'credit'},
                    {value: 'debit', text: 'debit'},
                    {value: 'credit-debit', text: 'credit-debit'},
                    {value: 'debit-credit', text: 'debit-credit'}
                ];

                optionsFormule.forEach(function(opt){
                    var option = document.createElement('option');
                    option.value = opt.value;
                    option.text = opt.text;
                    selectFormule.appendChild(option);
                });

                formuleInput.parentNode.replaceChild(selectFormule, formuleInput);
            }

            // Remplacer taxable_i
            var taxableInput = document.getElementById('taxable_' + i);
            if(taxableInput){
                var selectTaxable = document.createElement('select');
                selectTaxable.id = 'taxable_' + i;
                selectTaxable.name = 'taxable_' + i;
                selectTaxable.className = 'form-control';

                var optionsTaxable = [
                    {value: '0', text: 'Non'},
                    {value: '1', text: 'Oui'}
                ];

                optionsTaxable.forEach(function(opt){
                    var option = document.createElement('option');
                    option.value = opt.value;
                    option.text = opt.text;
                    selectTaxable.appendChild(option);
                });

                taxableInput.parentNode.replaceChild(selectTaxable, taxableInput);
            }
        }
    });
</script>

<% } catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();
</script>
<% }%>
