<%-- 
    Document   : pointage_visee_visa
    Created on : 8 mars 2019, 10:29:57
    Author     : EBI
--%>

<%@page import="paie.pointage.Pointage"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="paie.employe.ConstantePaie"%>

<% try {
    Pointage pointage_visa_multiple = new Pointage();
    pointage_visa_multiple.setNomTable("POINTAGEVISEE_VISA_MULTIPLE");
    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
        pointage_visa_multiple.setNomTable(request.getParameter("etat"));
    }
    String listeCrt[] = {"matricule", "moisLib", "annee", "directionLib"};
    String listeInt[] = {};
    String libEntete[] = {"id", "matricule", "personnel", "moisLib", "annee", "heureNormal", "heureSupNormal", "heureSupNuit", "heureSupFerie", "heureSupWeekend", "absence","directionLib"};
    PageRecherche pr = new PageRecherche(pointage_visa_multiple, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    pr.getFormu().getChamp("matricule").setLibelle("Matricule");
    pr.getFormu().getChamp("annee").setLibelle("Ann&eacute;e");

    affichage.Champ[] liste = new affichage.Champ[2];
    TypeObjet c = new TypeObjet();
    c.setNomTable("LOG_DIRECTION");
    liste[0] = new Liste("directionLib", c, "val", "val");
    TypeObjet[] mois = ConstantePaie.getMoisTous();
    liste[1] = new Liste("moisLib", mois, "val", "val");

    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("moisLib").setLibelle("Mois");
    pr.getFormu().getChamp("directionLib").setLibelle("Direction");

    String lienTableau[] = {pr.getLien() + "?but=paie/pointage/pointage-fiche.jsp"};
    String colonneLien[] = {"id"};

    pr.setApres("paie/pointage/pointage-visa.jsp");
    String[] colSomme = null;
    pr.setNpp(1000);
    pr.creerObjetPage(libEntete, colSomme);

    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String[] etatVal = {"POINTAGEVISEE_VISA_MULTIPLE", "PV_VISA_MULTIPLE_CREE", "PV_VISA_MULTIPLE_VISEE"};
    String[] etatAff = {"Tous", "Cr&eacute;&eacute;", "Vis&eacute;"};
%>
<script>
    function changerDesignation() {
        document.dossierInscription.submit();
    }
</script>

<div class="content-wrapper">
    <section class="content-header">
        <h1>Liste des pointages</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=paie/pointage/pointage-visa.jsp" method="post" name="dossierInscription" id="dossierInscription">
            <% out.println(pr.getFormu().getHtmlEnsemble()); %>
            <div class="row col-md-12 nopadding">
                <div class="col-md-2 nopadding">
                    &Eacute;tat :
                    <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                        <%
                            for( int i = 0; i < etatAff.length; i++ ){ %>
                        <% if(etatVal[i].equalsIgnoreCase(pointage_visa_multiple.getNomTable())) {%>
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
        <br>
        <br>

        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("PV_VISA_MULTIPLE_CREE") == 0) {%>
        <form action="<%=pr.getLien()%>?but=paie/pointage/visa_visee_multiple .jsp" method="post" name="incident" id="incident">
            <input type="hidden" name="bute" value="paie/pointage/pointage-visa.jsp"/>
            <input type="hidden" name="classe" value="pointage.Pointage"/>
            <input type="hidden" name="acte" value="viserPointageVisee"/>
            <%
                pr.getTableau().setNameActe("viserPointageVisee");
                pr.getTableau().setNameBoutton("Viser");
                String libEnteteAffiche[] = {"ID", "Matricule", "Nom et pr&eacute;noms", "Mois", "Ann&eacute;e", "Heure normal", "Heure sup normal", "Heure Maj Nuit", "Heure Maj F&eacute;ri&eacute;", "Heure Maj Week-end", "Absence", "Direction"};
                pr.getTableau().setLibelleAffiche(libEnteteAffiche);
                out.println(pr.getTableau().getHtmlWithCheckbox());
                out.println(pr.getBasPage());
            %>
        </form>
        <%
            } else {
                String libEnteteAffiche[] = {"ID", "Matricule", "Nom et pr&eacute;noms", "Mois", "Ann&eacute;e", "Heure normal", "Heure sup normal", "Heure Maj Nuit", "Heure Maj F&eacute;ri&eacute;", "Heure Maj Week-end", "Absence", "Direction"};
                pr.getTableau().setLibelleAffiche(libEnteteAffiche);
                out.println(pr.getTableau().getHtml());
                out.println(pr.getBasPage());
            }
        %>
    </section>
</div>

    <%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
