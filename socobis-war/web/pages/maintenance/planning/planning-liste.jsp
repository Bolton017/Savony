<%@page import="affichage.PageRecherche"%>
<%@ page import="maintenance.configuration.TypeMaintenance" %>
<%@ page import="affichage.Liste" %>
<%@ page import="maintenance.planning.PlanningCpl" %>

<% try{
    PlanningCpl t = new PlanningCpl();
    String listeCrt[] = {"id","refObjet","idTypeMaintenance","idMachineLib","datedebut","frequence","estPeriodique","etat"};
    String listeInt[] = {"datedebut","frequence"};
    String libEntete[] = {"id","refObjet","idTypeMaintenanceLib","idMachineLib","datedebut","duree","frequence","uniteLib","estPeriodiqueLib","etatLib"};
    String libEnteteAffiche[] = {"ID","R&eacute;f&eacute;rence","Type de maintenance","&Eacute;l&eacute;ment","Date de d&eacute;but","Dur&eacute;e","Fr&eacute;quence","Unit&eacute;","Est p&eacute;riodique","&Eacute;tat"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des plannings");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/planning/planning-liste.jsp");

    Liste[] liste = new Liste[3];
    TypeMaintenance c = new TypeMaintenance();
    liste[0] = new Liste("idTypeMaintenance",c,"val","id");
    String[] etatValP = {"","0","1"};
    String[] etatAffP = {"Tous","NON", "OUI"};
    liste[1] = new Liste("estPeriodique",etatAffP,etatValP);
    String[] etatVal = {"","1","11"};
    String[] etatAff = {"Tous","Cr&eacute;(e)", "Vis&eacute;(e)"};
    liste[2] = new Liste("etat",etatAff,etatVal);
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("refObjet").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("idMachineLib").setLibelle("&Eacute;l&eacute;ment");
    pr.getFormu().getChamp("idTypeMaintenance").setLibelle("Type de maintenance");
    pr.getFormu().getChamp("frequence1").setLibelle("Fr&eacute;quence min");
    pr.getFormu().getChamp("frequence2").setLibelle("Fr&eacute;quence max");
    pr.getFormu().getChamp("datedebut1").setLibelle("Date de d&eacute;but min");
    pr.getFormu().getChamp("datedebut2").setLibelle("Date de d&eacute;but max");
    pr.getFormu().getChamp("estPeriodique").setLibelle("Est p&eacute;riodique");
    pr.getFormu().getChamp("etat").setLibelle("&Eacute;tat");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=maintenance/planning/planning-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/planning/planning-saisie.jsp&currentMenu=MNDNMT0131\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir une maintenance planifi&eacute;e" +
            "                </a>"
    );

%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



