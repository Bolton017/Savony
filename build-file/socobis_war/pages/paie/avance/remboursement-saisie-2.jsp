<%@page import="affichage.PageConsulte"%>
<%@page import="paie.avance.Avance"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="paie.avance.Remboursement"%>

<%
    try {
        String lien = (String) session.getAttribute("lien");
        String id = request.getParameter("id"),
                nb_Remboursement = request.getParameter("nbremboursement"),
                colonneMere = request.getParameter("idpersonnel"),
                classeFille = "mg.fer.paie.Remboursement",
                redirection = "paie/avance/avance-fiche.jsp&id=" + id;

        Avance avance = new Avance();
        avance.setNomTable("AVANCE_LIB");

        PageConsulte pc = new PageConsulte(avance, request, (user.UserEJB) session.getValue("u"));
        pc.getChampByName("daty").setVisible(false);
        pc.getChampByName("idpersonnel").setLibelle("Personnel");
        pc.getChampByName("nbremboursement").setLibelle("Nombre de remboursements");
        pc.getChampByName("dateAvance").setLibelle("Date avance");
        pc.getChampByName("idTypeAvance").setLibelle("Type avance");
        pc.setTitre("Fiche Avance");

        Avance base = (Avance) pc.getBase();
        int nbremboursement = base.getNbremboursement();
        double interet = base.getInteret()/100;

        Remboursement fille = new Remboursement();
        String[] mois = {"Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Decembre"};
        int finMois = mois.length, j = 0, mois_av = Utilitaire.getMois(base.getDateAvance()), annee = Utilitaire.getAnnee(base.getDateAvance());

        double montant_int = (base.getMontant()*interet) + base.getMontant();
        int montant = (int) montant_int / nbremboursement;

        fille.setNomTable("Remboursement");
        fille.setIdavance(id);
        Remboursement[] lsP = fille.listPlanRemb("", null);

        int currentMonth = mois_av;
        int currentYear = annee;


        if (lsP.length > 0) {
%>
<script>document.location.replace("<%=lien%>?but=paie/avance/remboursement-modif.jsp&id=<%=base.getId()%>");</script>
<%
        return;
    }
%>

<div class="content-wrapper">
    <h1 class="box-title">
        <a href="<%= lien + "?but=paie/avance/avance-fiche.jsp&id=" + id %>">
            <i class="fa fa-angle-left"></i>
        </a>Fiche avance
    </h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%= pc.getHtml() %>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="cardradius">
        <div class="box-header">
            <h3 class="box-title h520pxSemibold m-0">Plan de Remboursement</h3>
        </div>
        <form action="<%=lien%>?but=apresTarifMultiple.jsp" method="post" name="remboursement" id="remboursement">
            <table class="table table-bordered table-condensed">
                <thead>
                <tr class="head">
                    <th width="11%" align="center" valign="top" class='contenuetable'>Mois</th>
                    <th width="11%" align="center" valign="top" class='contenuetable'>Ann&eacute;e</th>
                    <th width="11%" align="center" valign="top" class='contenuetable'>Montant</th>
                </tr>
                </thead>
                <tbody>
                <% for (int i = 0; i < nbremboursement; i++) {
                    int displayMonth = (currentMonth % 12 == 0) ? 12 : (currentMonth % 12);
                    int displayYear = currentYear + (currentMonth - 1) / 12; %>
                <tr>
                    <input type="hidden" class="form-control" id="iddemande<%=i%>" name="iddemande<%=i%>" value="<%=id%>">
                    <td width="11%" align="left">
                        <select name="mois<%=i%>" class="form-control" id="mois<%=i%>">
                            <% for (j = 0; j < finMois; j++) { %>
                            <option value="<%= (j + 1) %>" <%= (j + 1 == displayMonth) ? "selected" : "" %>>
                                <%= mois[j] %>
                            </option>
                            <% } %>
                        </select>
                    </td>
                    <td>
                        <input class="form-control" type="number" id="annee<%=i%>" name="annee<%=i%>" value="<%= displayYear %>">
                    </td>
                    <td>
                        <input class="form-control" type="number" id="montant<%=i%>" name="montant<%=i%>"
                               value="<%= (i + 1 == nbremboursement ? montant_int - (montant * (nbremboursement - 1)) : montant) %>">
                    </td>
                </tr>

                <%
                        currentMonth++;} %>
                </tbody>
            </table>

            <input type="hidden" name="acte" value="savePlanRemboursement">
            <input type="hidden" name="bute" value="<%= redirection %>">
            <input type="hidden" name="idMere" value="<%= base.getId() %>">
            <input type="hidden" name="classefille" value="<%= classeFille %>">
            <input type="hidden" name="nombreLigne" value="<%= nbremboursement %>">
            <input type="hidden" name="colonneMere" value="<%= colonneMere %>">

            <div class="box-footer">
                <input type="submit" class="btn btn-primary pull-right" value="Enregistrer">
            </div>
        </form>
    </div>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script>alert('<%= e.getMessage() %>'); history.back();</script>
<% } %>
