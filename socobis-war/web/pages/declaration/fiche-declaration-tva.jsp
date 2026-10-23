<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="declaration.DeclarationTvaLib" %>
<%@ page import="declaration.DeclarationTva" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="declaration.ImprimerDeclaration" %>
<%@ page import="java.util.Map" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    DeclarationTvaLib o = new DeclarationTvaLib();
    o.setNomTable("DECLARATIONTVALIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre(" Fiche d'une d&eacute;claration Tva");
    String id = pc.getBase().getTuppleID();
    DeclarationTvaLib base = (DeclarationTvaLib) pc.getBase();
    pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("designation").setLibelle("D&eacute;signation");
    pc.getChampByName("datydebut").setLibelle("Date de d&eacute;but");
    pc.getChampByName("datyfin").setLibelle("Date de fin");
    pc.getChampByName("etatLib").setVisible(false);
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("Montantpayer").setLibelle("Montant pay&eacute;/report&eacute;");
    pc.getChampByName("payementLib").setLibelle("&Eacute;tat de paiement");
    /*
    DeclarationTva dec = new DeclarationTva(base.getDatydebut(),base.getDatyfin());
    HashMap<String, ImprimerDeclaration> res = dec.getDonnees();
    for (Map.Entry<String, ImprimerDeclaration> entry : res.entrySet()) {
        String key = entry.getKey();
        ImprimerDeclaration value = entry.getValue();

        System.out.println("Clé : " + key);
        System.out.println("Valeur : " + value.getMontant());
    }

     */
    String[] ordre = {"id","designation","datydebut","datyfin","etatLib"};
    pc.setOrdre(ordre);

    String pageRetour = ".jsp";
    String pageModif = "declaration/declaration-tva.jsp&acte=update";
    String pageApresDelete = "liste-declaration-tva.jsp";
    String classe = "declaration.DeclarationTva";
    String pageActuel = "declaration/fiche-declaration-tva.jsp";
    String paramSup = "&datydebut="+pc.getChampByName("datydebut").getValeur();
    paramSup += "&datyfin="+pc.getChampByName("datyfin").getValeur();

    Map<String, String> map = new HashMap<String, String>();
    map.put("detail-declaration-tva", "");
    map.put("sous-ecriture-detail", "");
    map.put("facture-declaration-tva", "");

    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "detail-declaration-tva";
    }
    map.put(tab, "active");
    tab ="inc/"+ tab + ".jsp";
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
                        <% if(base.getEtat()==1){%>
                            <a class="btn btn-secondary pull-right" href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=apresTarif.jsp&id=" + request.getParameter("id")%>&acte=valider&bute=declaration/fiche-declaration-tva.jsp&classe=<%=classe%>" style="margin-right: 10px">Viser</a>
                        <% } %>
                        <% if(base.getEtat()==11){%>
                            <a class="btn btn-secondary pull-right"  href="<%= lien + "?but=declaration/apresPayer.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Payer ou Reporter</a>
                            <a class="btn btn-tertiary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=imprimerDeclaration&id=<%=id%>" style="margin-right: 10px">Imprimer</a>
                        <% } %>
                    </div>
                    <br/>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("detail-declaration-tva")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=detail-declaration-tva">Détails</a></li>
                    <li class="<%=map.get("sous-ecriture-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=sous-ecriture-detail<%=paramSup%>">Sous &eacute;critures</a></li>
                    <li class="<%=map.get("facture-declaration-tva")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=facture-declaration-tva<%=paramSup%>">Facture de d&eacute;claration de TVA</a></li>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
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

