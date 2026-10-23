<%@page import="caisse.MouvementCaisseMereCpl"%>
<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@page import="java.util.*"%>
<%@page import="utils.ConstanteSocobis"%>
<%@page import="utilitaire.ConstanteEtat"%>

<%
    UserEJB u = (UserEJB) session.getValue("u");
%>

<%
    String lien = (String) session.getValue("lien");
    MouvementCaisseMereCpl mere = new MouvementCaisseMereCpl();
    mere.setNomTable("mouvementcaissemerelib");
    PageConsulte pc = new PageConsulte(mere, request, u);
    pc.setTitre("Fiche Mouvement de Caisse");
    mere = (MouvementCaisseMereCpl) pc.getBase();
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("idmodepaiementlib").setLibelle("Mode de paiement");
    pc.getChampByName("credit").setLibelle("Montant");
    pc.getChampByName("idtierslib").setLibelle("Client");
    pc.getChampByName("idorigine").setLibelle("Origine");
    pc.getChampByName("idorigine").setLien(lien+"?but=vente/vente-fiche.jsp", "id=");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idtiers").setVisible(false);
    pc.getChampByName("idmodepaiement").setVisible(false);
    pc.getChampByName("debit").setVisible(false);
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("etat").setVisible(false);

    String pageActuel = "caisse/mvtcaisse-fiche-mf.jsp";

    String pageModif = "caisse/mvtcaisse-saisie-multiple.jsp&acte=update";
    String classe = "caisse.MouvementCaisseMere";

    Map<String, String> map = new HashMap<String, String>();
    map.put("mvtcaissefille-liste", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "mvtcaissefille-liste";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title">
        <a href="<%= lien + "?but=caisse/mvtcaisse-liste.jsp"%>">
            <i class="fa fa-angle-left"></i>
        </a>
        <%= pc.getTitre() %>
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
                        <div class="box-footer">
                            <%
                                if (mere.getEtat() < ConstanteEtat.getEtatValider()) {
                            %>
                            <a class="btn btn-primary pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=caisse/mvtcaisse-fiche-mf.jsp&classe=" + classe %>" style="margin-right: 10px">Viser</a>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but=" + pageModif + "&id=" + id %>" style="margin-right: 10px">Modifier</a>
                            <a class="pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id + "&acte=annuler&bute=caisse/mvtcaisse-liste.jsp&classe=" + classe %>"> <button class="btn btn-danger">Annuler</button> </a>
                            <% } else { %>
                                <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&acte=annulerVisa&id=" + id + "&bute=caisse/mvtcaisse-fiche-mf.jsp&classe=" + classe %>" style="margin-right: 10px">Annuler</a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <li class="<%=map.get("mvtcaissefille-liste")%>">
                        <a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=mvtcaissefille-liste">
                            D&eacute;tails mouvements
                        </a>
                    </li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>">
                        <jsp:param name="idmvtcaissemere" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>
        </div>
    </div>
</div>
