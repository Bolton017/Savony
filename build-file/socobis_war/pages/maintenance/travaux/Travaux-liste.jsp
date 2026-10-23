
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="maintenance.travaux.TravauxCpl" %>

<% try{
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    TravauxCpl t = new TravauxCpl();
    String nomTable = "TRAVAUXCPL";
    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
        nomTable = request.getParameter("etat");
    }
    t.setNomTable(nomTable);

    String listeCrt[] = {"id", "lanceparLib", "remarque", "libelle", "daty","idOf","idOffille"};
    String listeInt[] = {"daty"};
//    alana ny ordre de travaux
//    String libEntete[] = {"id", "lanceparLib", "remarque", "libelle", "daty","idOf","idOffille","etatLib"};
    String libEntete[] = {"id", "lanceparLib", "remarque", "libelle", "daty","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des Travaux");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("maintenance/travaux/Travaux-liste.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idOf").setLibelle("Id Ordre de travaux");
    pr.getFormu().getChamp("idOffille").setLibelle("Id Ordre de travaux fille");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("lanceparLib").setLibelle("Lanc&eacute;e par");
    pr.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=maintenance/travaux/Travaux-fiche.jsp" , pr.getLien() + "?but=maintenance/travaux/Otravaux-fiche.jsp", pr.getLien() + "?but=maintenance/travaux/Otravaux-details-fiche.jsp"};
    String colonneLien[] = {"id" ,"idOf","idOffille"}; // Colonne contenant un lien, passé comme paramètre dans l'URL
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Remplacer le nom de l'attribut passé dans l'URL, par exemple passer 'idObjet' au lieu de 'id' du colonneLien
    String[] urlLienMultiple = {"id", "idOf","idOffille"};
    String[] urlLienAffiche = {"id", "id","id"};
    //String[] attributLien = {"id"};
    //pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setUrlLienAffiche(urlLienAffiche);
    pr.getTableau().setUrlLien(urlLienMultiple);
//    pr.getFormu().setAnotherButton(
//        "                <a class=\"btn btn-primary pull-right btn-small\" href=\"module.jsp?but=maintenance/travaux/Travaux-saisie.jsp&currentMenu=MNDNMT0122\">\n" +
//        "                    <i class=\"material-symbols-rounded\">add</i>Saisir un ex&eacute;cution de travaux" +
//        "                </a>"
//    );



    //Definition des libelles à afficher
//    alana ny ordre de travaux
//    String libEnteteAffiche[] = {"ID", "Lanc&eacute;e par", "Remarque", "D&eacute;signation", "Date","Id ordre de travaux","Id Ordre de travaux fille","&eacute;tat"};
    String libEnteteAffiche[] = {"ID", "Entit&eacute;", "Remarque", "D&eacute;signation", "Date","&eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("maintenance/travaux/inc/fabrication-details.jsp&id=");
    String[] etatVal = {"TRAVAUXCPL","TRAVAUXCPLCREE", "TRAVAUXCPLVISEE", "TRAVAUXCPLANNULE","TRAVAUXCPLENTAMEE","TRAVAUXCPLBLOQUEE","TRAVAUXCPLTERMINEE"};
    String[] etatAff = {"Tous","Cr&eacute;&eacute;e(s)","Valid&eacute;e(s)","Annul&eacute;e(s)","Entam&eacute;e(s)","Bloqu&eacute;e(s)","Termin&eacute;e(s)"};

%>
<script>
    function changerDesignation() {
        document.getElementById("bdlc-liste--form").submit();
    }
</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdlc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <%
                            for( int i = 0; i < etatAff.length; i++ ){ %>
                        <% if(etatVal[i].equalsIgnoreCase(t.getNomTable())) {%>
                        <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                        <% } else { %>
                        <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                        <% } %>
                        <%    }
                        %>
                    </select>
                </div>
            </div>
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



