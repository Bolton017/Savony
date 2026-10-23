<%@page import="prevision.Prevision" %>
<%@page import="caisse.Caisse" %>
<%@page import="affichage.*" %>
<%@page import="user.*" %>
<%@page import="utils.*" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="prevision.Service" %>
<%@ page import="budget.Budget" %>

<%
    try{
        UserEJB user = (UserEJB) session.getValue("u");
        String lien = (String) session.getValue("lien");
        Budget budget = new Budget();
        PageInsert pageInsert = new PageInsert(budget, request, user);
        pageInsert.setLien(lien);
        affichage.Champ[] liste = new affichage.Champ[3];
        liste[0] = new Liste("iddevise",new caisse.Devise(),"val","id");
        String[] valMois = {"1","2","3","4","5","6","7","8","9","10","11","12"};
        String[] affMois = {"Janvier","F&eacute;vrier","Mars","Avril","Mai","Juin","Juillet","Ao&ucirc;t","Septembre","Octobre","Novembre","D&eacute;cembre"};
        liste[1] = new Liste("mois" ,affMois,valMois);
        liste[2] = new Liste("service",new Service(),"libelle","compte");
        Caisse c = new Caisse();
        c.setIdPoint(ConstanteStation.getFichierCentre());

        pageInsert.getFormu().changerEnChamp(liste);
        pageInsert.getFormu().getChamp("designation").setDefaut("Budget du "+utilitaire.Utilitaire.dateDuJour());
        pageInsert.getFormu().getChamp("daty").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pageInsert.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pageInsert.getFormu().getChamp("idDevise").setLibelle("Devise");
        pageInsert.getFormu().getChamp("debit").setLibelle("d&eacute;pense");
        pageInsert.getFormu().getChamp("credit").setLibelle("recette");
        pageInsert.getFormu().getChamp("iddevise").setDefaut("AR");
        pageInsert.getFormu().getChamp("taux").setDefaut("1");
        pageInsert.getFormu().getChamp("compte").setLibelle("Compte de regroupement");
        pageInsert.getFormu().getChamp("service").setLibelle("D&eacute;partement");
        pageInsert.getFormu().getChamp("daty").setVisible(false);
        pageInsert.getFormu().getChamp("etat").setVisible(false);
        //pageInsert.getFormu().getChamp("id").setVisible(false);
        pageInsert.getFormu().getChamp("debit").setVisible(true);
        //pageInsert.getFormu().getChamp("etat").setVisible(false);
        pageInsert.getFormu().getChamp("idorigine").setVisible(false);
        pageInsert.getFormu().getChamp("daty").setLibelle("Date");
        pageInsert.getFormu().getChamp("mois").setLibelle("Mois");
        pageInsert.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");
        pageInsert.getFormu().getChamp("mois").setDefaut(utilitaire.Utilitaire.getMois(utilitaire.Utilitaire.dateDuJour()));
        pageInsert.getFormu().getChamp("annee").setDefaut(utilitaire.Utilitaire.getAnnee(utilitaire.Utilitaire.dateDuJour()));

        String classe = "budget.Budget";
        String nomTable = "PREVISION";
        String butApresPost = "budget/budget-fiche.jsp";

        pageInsert.preparerDataFormu();
        pageInsert.getFormu().makeHtmlInsertTabIndex();


%>



<div class="content-wrapper">
    <h1 align="center">Saisie Budget </h1>
    <form class="container" action="<%=pageInsert.getLien()%>?but=apresTarif.jsp" method="post">
        <%
            out.println(pageInsert.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
    }

%>