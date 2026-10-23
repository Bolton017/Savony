<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@page import="paie.employe.BanqueAgence"%>


<% try {
    UserEJB u = (user.UserEJB)session.getValue("u");

    String nomtable = "Banque_agence";
    BanqueAgence service = new BanqueAgence();
    service.setNomTable(nomtable);

    PageConsulte pc = new PageConsulte(service, request, u);
    pc.setTitre("Fiche de Banque Agence");
    pc.getBase();
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("nom").setLibelle("Nom");
    pc.getChampByName("codeAgence").setLibelle("Code Agence");
    pc.getChampByName("idBanque").setLibelle("Banque");

    String lien = (String) session.getValue("lien");
    String classe = "paie.employe.BanqueAgence";
    String pageListe = "paie/employe/banqueagence-liste.jsp";
%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but="+pageListe+""%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a  class="pull-left btn btn-danger" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+ pageListe + "&classe="+classe+"&nomtable=" + nomtable %>" style="margin-right: 10px">Supprimer</a>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<% } catch (Exception e) {
    e.printStackTrace();
}%>
