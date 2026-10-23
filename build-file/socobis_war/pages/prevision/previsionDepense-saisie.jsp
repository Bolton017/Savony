<%@page import="prevision.Prevision" %>
<%@page import="caisse.Caisse" %>
<%@page import="affichage.*" %>
<%@page import="user.*" %>
<%@page import="utils.*" %>

<%
    try{
        int taille = 10;
        UserEJB user = (UserEJB) session.getValue("u");
        String lien = (String) session.getValue("lien");
        Prevision prevision = new Prevision();
        PageInsertMultiple pi = new PageInsertMultiple(prevision, prevision, request, 10, user);
        pi.setLien(lien);
        affichage.Champ[] liste = new affichage.Champ[1];
        liste[0] = new Liste("idDevise",new caisse.Devise(),"val","id");
        Caisse c = new Caisse();
        c.setIdPoint(ConstanteStation.getFichierCentre());

        pi.getFormufle().changerEnChamp(liste);
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("designation"),"Prevision du "+utilitaire.Utilitaire.dateDuJour());
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("taux"),"1");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idTiers"),"pertegain.Tiers","id","tiers");

        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChamp("taux_0").setLibelle("Taux");
        pi.getFormufle().getChamp("debit_0").setLibelle("d&eacute;pense");
        pi.getFormufle().getChamp("credit_0").setLibelle("recette");
        pi.getFormufle().getChamp("idDevise_0").setDefaut("AR");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte de regroupement");
        pi.getFormufle().getChamp("daty_0").setLibelle("Date");
        pi.getFormufle().getChamp("idTiers_0").setLibelle("Tiers");

        String[] champCache = {"credit","idCaisse","idVirement","idVenteDetail","idOp","etat","idOrigine","idFacture"};
        for (String champ : champCache){
            affichage.Champ.setVisible(pi.getFormufle().getChampFille(champ), false);
        }

        String classe = "prevision.Prevision";
        String nomTable = "PREVISION";
        String butApresPost = "prevision/prevision-liste.jsp";
        String[] champOrdre={"daty","designation","debit","credit","idDevise","taux","idTiers","compte","idCaisse","idVirement","idVenteDetail","idOp","idOrigine","idFacture","etat"};
        pi.getFormufle().setColOrdre(champOrdre);
        pi.preparerDataFormu();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Saisie des dépenses pr&eacute;visionnelles </h1>
    </section>
    <form action="<%=pi.getLien()%>?but=prevision/apresMultiplePrevision.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="classefille" type="hidden" id="classefille" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
    </form>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
    }

%>