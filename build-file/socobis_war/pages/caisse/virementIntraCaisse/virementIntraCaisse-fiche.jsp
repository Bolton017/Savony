<%--
    Document   : page-fiche-simple
    Created on : 9 mars 2023, 10:08:42
    Author     : BICI
--%>

<%@page import="constante.ConstanteEtat"%>
<%@page import="caisse.VirementIntraCaisseCpl"%>
<%@ page import="affichage.*" %>

<%
    try{

    String lien = (String) session.getValue("lien");
    VirementIntraCaisseCpl t = new VirementIntraCaisseCpl();
    t.setNomTable("VirementIntraCaisseCpl");
    PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
    String id=pc.getBase().getTuppleID( );
    t=(VirementIntraCaisseCpl)pc.getBase();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("idCaisseDepartLib").setLibelle("Tr&eacute;sorerie de d&eacute;part");
        pc.getChampByName("idCaisseDepartLib").setLien(lien + "?but=caisse/caisse-fiche.jsp&id="+t.getIdCaisseDepart(),"nom=");
        pc.getChampByName("idCaisseArriveLib").setLibelle("Tr&eacute;sorerie d'arriv&eacute;e");
        pc.getChampByName("idCaisseArriveLib").setLien(lien + "?but=caisse/caisse-fiche.jsp&id="+t.getIdCaisseArrive(),"nom=");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");
        pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idCaisseDepart").setVisible(false);
        pc.getChampByName("idCaisseArrive").setVisible(false);
        pc.getChampByName("etatLib").setVisible(false);
    pc.setTitre("Fiche virement intra caisse ");
    String pageModif = "caisse/virementIntraCaisse/virementIntraCaisse-saisie.jsp";
    String classe = "caisse.VirementIntraCaisse";
%>
<div class="content-wrapper">
    <h1 class="box-title"><a href="<%= lien + "?but=caisse/virementIntraCaisse/virementIntraCaisse-liste.jsp"%>"><i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if (t.getEtat() < ConstanteEtat.getEtatValider() && t.getEtat() > ConstanteEtat.getEtatAnnuler()) { %>
                                    <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=caisse/virementIntraCaisse/virementIntraCaisse-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                                    <a class="btn btn-secondary pull-right"  href="<%= lien + "?but="+ pageModif +"&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
<%--                                    <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=caisse/virementIntraCaisse/virementIntraCaisse-liste.jsp&classe="+classe+"&nomtable=VirementIntraCaisse" %>" style="margin-right: 10px">Supprimer</a>--%>
                            <%    }  %>
                            <% if (t.getEtat()== ConstanteEtat.getEtatCreer()) { %>
                                    <a  class="btn btn-danger pull-left"  href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=caisse/virementIntraCaisse/virementIntraCaisse-fiche.jsp&classe="+classe %>" style="margin-right: 10px !important">Annuler</a>
                            <%    }  %>

                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<%
} catch (Exception e) {
    e.printStackTrace();
} %>


