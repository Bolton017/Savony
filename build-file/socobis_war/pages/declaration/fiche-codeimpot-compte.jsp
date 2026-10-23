<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="declaration.LiaisonCodeImpotLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>

<% try{
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    LiaisonCodeImpotLib o = new LiaisonCodeImpotLib();
    o.setNomTable("LIAISONCODELIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche du compte par code impôt");
    String id = pc.getBase().getTuppleID();
    LiaisonCodeImpotLib base = (LiaisonCodeImpotLib) pc.getBase();
    pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("Idcodeimpot").setLibelle("Code");
    pc.getChampByName("Idcompte").setLibelle("Compte");
    pc.getChampByName("IdCodeImpotLib").setLibelle("Libell&eacute;");

    String[] ordre = {"id","Idcodeimpot","IdCodeImpotLib","Idcompte","formule","taxable"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "declaration//saisie-codeimpot-compte.jsp&acte=update";
    String pageApresDelete = "declaration/liste-codeimpot-compte.jsp";
    String classe = "declaration.LiaisonCodeImpotLib";
    String pageActuel = "declaration/fiche-codeimpot-compte.jsp";

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
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>&classe=<%=classe%>" style="margin-right: 10px">Modifier</a>
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
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

