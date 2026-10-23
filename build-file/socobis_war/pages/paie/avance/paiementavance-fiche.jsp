
<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="paie.avance.Avance"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="paie.avance.Remboursement"%>
<%@ page import="paie.avance.PaiementAvance" %>
<%@ page import="utilitaire.ConstanteEtat" %>
<%@ page import="paie.avance.PaiementAvanceLib" %>

<%
    try{
        String dossier = "pa";
        String pageActuel = "paie/avance/paiementavance-fiche.jsp";
        String lien = (String)session.getAttribute("lien");
        PaiementAvanceLib base = new PaiementAvanceLib();
        PageConsulte pc = new PageConsulte(base, request, (user.UserEJB) session.getValue("u"));
        pc.getChampByName("idavance").setLibelle("Avance");
        pc.getChampByName("idavance").setLien(lien + "?but=paie/avance/avance-fiche.jsp","id");
        pc.getChampByName("datepaiement").setLibelle("Date de paiement");
        pc.getChampByName("modepaiement").setLibelle("Mode de paiement");
        pc.getChampByName("annee").setLibelle("Ann&eacute;e");
        pc.getChampByName("mois").setVisible(false);
        pc.getChampByName("moisLib").setLibelle("Mois");
        pc.getChampByName("typeAvanceLib").setLibelle("Type de l'avance");
        pc.getChampByName("montant").setLibelle("Montant");
        pc.getChampByName("debiterSalaire").setLibelle("Debiter sur salaire");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        pc.getChampByName("etatLib").setVisible(false);

        base = (PaiementAvanceLib) pc.getBase();
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=paie/avance/paiementavance-liste.jsp"%> <i class="fa fa-arrow-circle-left"></a>Fiche de paiement d'avance</h1>
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">

                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer" >
                            <%if (base.getEtat()< ConstanteEtat.getEtatValider()){ %>
                            <a class="btn btn-success pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + base.getId() + "&bute="+pageActuel+"&classe=paie.avance.PaiementAvance&nomtable=PAIEMENTAVANCE"%> " style="margin-right: 10px">Viser</a>
                            <a class="btn btn-warning pull-right"  href="<%=(String) session.getValue("lien") + "?but=paie/avance/paiementavance-saisie.jsp&acte=update&id=" + base.getId()%>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                            <a class="btn btn-info pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + base.getId() + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + base.getId() %>" style="margin-right: 10px;">Attacher Fichier</a>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <%=pc.getHtmlAttacherFichier()%>
</div>
</div>
</div>

<%
}catch(Exception e){
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
