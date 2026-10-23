<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="machine.ElementInspectionMachineLib" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    ElementInspectionMachineLib o = new ElementInspectionMachineLib();
    o.setNomTable("ELEMENTINSPECTIONMACHINELIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un &eacute;l&eacute;ment &agrave; insp&eacute;cter dans une machine");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("idElementInspectionLib").setLibelle("&eEcutel&eacutement &agrave; inspecter");
    pc.getChampByName("idMachineLib").setLibelle("Machine");
    pc.getChampByName("idelementinspection").setVisible(false);
    pc.getChampByName("idmachine").setVisible(false);

    String[] ordre = {"id","idElementInspectionLib","idMachineLib"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "machine/elementInspectionMachine-saisie.jsp&acte=update";
    String pageApresDelete = "machine/elementInspectionMachine-liste.jsp";
    String classe = "machine.ElementInspectionMachineLib";

%>

<div class="content-wrapper">

<h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

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
                        <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                    </div>
                    <br/>
                </div>
            </div>
        </div>
    </div>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

