

<%@page import="paie.log.LogPersnonValideComplet"%>
<%@page import="affichage.Liste"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="affichage.PageRecherche"%>

<%
    try{
    LogPersnonValideComplet dr = new LogPersnonValideComplet();
    String nomTable = "LOG_PERS_NON_VALIDE_LIB";

    if (request.getParameter("table") != null && request.getParameter("table").compareToIgnoreCase("") != 0) {
            nomTable = request.getParameter("table");
    }
    dr.setNomTable(nomTable);

    String listeCrt[] = {"id", "matricule", "idlogpers", "dateapplication", "idtypedebauche"};
    String listeInt[] = {"dateapplication"};
    String libEntete[] = {"id", "matricule", "idlogpers", "dateapplication", "idtypedebauche", "etatLib"};
    PageRecherche pr = new PageRecherche(dr, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.getFormu().getChamp("dateapplication1").setLibelle("Date d'application min");
    pr.getFormu().getChamp("dateapplication2").setLibelle("Date d'application max");
    pr.getFormu().getChamp("idlogpers").setLibelle("Personnel");
    pr.getFormu().getChamp("idtypedebauche").setLibelle("Cause de d&eacute;part");
    pr.setApres("paie/employe/personnelnonvalide-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=paie/employe/personnelnonvalide-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"id", "Matricule", "Nom et pr&eacute;noms", "Date d'application", "Cause", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatVal = {"LOG_PERS_NON_VALIDE_LIB","LOG_PERS_NON_VALIDE_LIB_CREE", "LOG_PERS_NON_VALIDE_LIB_VISE", "LOG_PERS_NON_VALIDE_LIB_STC"};
    String[] etatAff = {"Tous","Cr&eacute;e"," Vis&eacute;e","STC"};
         pr.getFormu().setAnotherButton(
            "                <a class=\"btn btn-primary pull-right  btn-small\" href=\"module.jsp?but=paie/employe/personnelnonvalide-saisie.jsp&currentMenu=ELM000658\">\n" +
            "                    <i class=\"material-symbols-rounded\">add</i> Saisir un d&eacute;part\n" +
            "                </a>"
        );

%>
<script>
    function changerDesignation() {
        document.incident.submit();
    }
</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des personnels non valides</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/employe/personnelnonvalide-liste.jsp" method="post" name="incident" id="incident">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <%
                            for( int i = 0; i < etatAff.length; i++ ){ %>
                        <% if(etatVal[i].equalsIgnoreCase(dr.getNomTable())) {%>
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
        %>
    </section>
</div>
<% } catch(Exception e) { e.printStackTrace();}%>
