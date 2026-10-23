<%@page import="affichage.PageRecherche"%>
<%@ page import="maintenance.configuration.Entite" %>
<%@ page import="maintenance.configuration.Situation" %>
<%@ page import="affichage.Liste" %>
<%@ page import="maintenance.ressources.Machine" %>
<%@ page import="maintenance.planning.DemandeTravauxCpl" %>
<%@ page import="maintenance.ressources.DepartementMaintenance" %>
<%@ page import="bean.TypeObjet" %>

<% try{
    DemandeTravauxCpl t = new DemandeTravauxCpl();
    String listeCrt[] = {"id","description","idEntite","idMachine","idSituation","daty","dateBesoin","prioriteLib","estExistant","etat","idDepartement"};
    String listeInt[] = {"daty","dateBesoin"};
    String libEntete[] = {"id","description","daty","dateBesoin","idEntiteLib","idMachineLib","idSituationLib","idDepartementLib","prioriteLib","estExistantLib","etatLib"};
    String libEnteteAffiche[] = {"ID","Description","Date de la demande","Date de besoin","Entit&eacute;","&Eacute;l&eacute;ment","Situation","D&eacute;partement","Priorit&eacute;","Probl&egrave;me d&eacute;j&agrave; rencontr&eacute;","&Eacute;tat"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des demandes de travaux");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/demandetravaux/demandetravaux-liste.jsp");

    Liste[] liste = new Liste[7];
    Entite c = new Entite();
    liste[0] = new Liste("idEntite",c,"val","id");
    Situation c2 = new Situation();
    liste[1] = new Liste("idSituation",c2,"val","id");
    Machine c3 = new Machine();
    liste[2] = new Liste("idMachine",c3,"val","id");
    liste[3] = new Liste("estExistant");
    liste[3].makeListeOuiNon();
    String[] etatVal = {"","1","11"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)", "Vis&eacute;e(s)"};
    liste[4] = new Liste("etat",etatAff,etatVal);
    DepartementMaintenance c4 = new DepartementMaintenance();
    liste[5] = new Liste("idDepartement",c4,"val","id");
    liste[6] = new Liste("priorite",new TypeObjet("priorite"),"val","id");
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("idEntite").setLibelle("Entit&eacute;");
    pr.getFormu().getChamp("idMachine").setLibelle("&Eacute;l&eacute;ment");
    pr.getFormu().getChamp("idSituation").setLibelle("Situation");
    pr.getFormu().getChamp("daty1").setLibelle("Date de la demande — du");
    pr.getFormu().getChamp("daty2").setLibelle("Date de la demande — au");
    pr.getFormu().getChamp("dateBesoin1").setLibelle("Date de besoin min");
    pr.getFormu().getChamp("dateBesoin2").setLibelle("Date de besoin max");
    pr.getFormu().getChamp("prioriteLib").setLibelle("Priorit&eacute;");
    pr.getFormu().getChamp("estExistant").setLibelle("Probl&egrave;me d&eacute;j&agrave; rencontr&eacute;");
    pr.getFormu().getChamp("etat").setLibelle("&Eacute;tat");
    pr.getFormu().getChamp("idDepartement").setLibelle("D&eacute;partement de maintenance ");


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=maintenance/demandetravaux/demandetravaux-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/demandetravaux/demandetravaux-saisie.jsp&currentMenu=MNDNMT0129\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i>Saisir une demande de travaux" +
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



