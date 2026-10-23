
<%@page import="paie.edition.PaieFonction"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%!
    PaieFonction pf;
%>
<%
    try {
        pf = new PaieFonction();
        pf.setNomTable("PAIE_FONCTIONLIBELLE");
        String[] libellePriseChargeFiche = {"Id", "Code de la fonction", "Description", "Groupe"};
        PageConsulte pc = new PageConsulte(pf, request, (user.UserEJB) session.getValue("u"));
        String id = pc.getBase().getTuppleID();
        pc.setLibAffichage(libellePriseChargeFiche);
        pc.setTitre("Fiche de la fonction");
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=compta/exercice/ouvertureCloture.jsp">
        <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%>
    </h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                    </br>
                        <div class="box-footer">
                            <a class="btn btn-primary pull-right"  href="<%=(String) session.getValue("lien") + "?but=paie/fonction/paiefonction-saisie.jsp&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-danger pull-left"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&id=" + id %>&acte=delete&bute=paie/fonction/paiefonction-liste.jsp&classe=paie.edition.PaieFonction" style="margin-right: 10px">Supprimer</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%} catch (Exception ex) {
        ex.printStackTrace();
    }%>
