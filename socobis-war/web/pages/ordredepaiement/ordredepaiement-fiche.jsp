<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="ordredepaiement.OrdreDePaiementLib" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="constante.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");

    OrdreDePaiementLib o = new OrdreDePaiementLib();
    o.setNomTable("ORDREDEPAIEMENTLIB");
    PageConsulte pc = new PageConsulte(o, request, u);
    pc.setTitre("Fiche d'un ordre de paiement");
    String id = pc.getBase().getTuppleID();
    o = (OrdreDePaiementLib) pc.getBase();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("idfacts").setLibelle("Factures");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("montant").setLibelle("Montant total");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("numeroop").setLibelle("Num&eacute;ro op&eacute;ration");
    pc.getChampByName("modepaiement").setVisible(false);
    pc.getChampByName("tiers").setVisible(false);
    pc.getChampByName("iduser").setVisible(false);
    pc.getChampByName("tiersLib").setLibelle("Tiers");
    pc.getChampByName("modepaiementLib").setLibelle("Mode de paiement");

    String[] ordre = {"id","idfacts","daty","montant","remarque","etat","numeroop","modepaiement","tiers","iduser"};
    pc.setOrdre(ordre);

    String pageActuel = "ordredepaiement/ordredepaiement-fiche.jsp";
    String pageRetour = ".jsp";
    String pageModif = "ordredepaiement/ordredepaiement-saisie.jsp&acte=update";
    String pageApresDelete = "ordredepaiement/ordredepaiement-liste.jsp";
    String classe = "ordredepaiement.OrdreDePaiement";

    Map<String, String> map = new HashMap<>();
    map.put("inc/opfactures", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/opfactures";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";
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
                        <% if (o.getEtat() < ConstanteEtat.getEtatValider()) { %>
                        <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=ordredepaiement/ordredepaiement-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                        <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id %>" style="margin-right: 10px">Modifier</a>
                        <a  style="margin-right: 10px" class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                       
                        <% }
                         if (o.getEtat() == ConstanteEtat.getEtatValider()) { %>
                             <a class="btn btn-success pull-right" href="<%= lien + "?but=ordredepaiement/mvtCaisse-saisie-sortie.jsp&idOrdre=" + id %>" style="margin-right: 10px"> Générer Mouvement Caisse</a>
                        <% } %>
                    </div>
                    <br/>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="row m-0">
    <div class="col-md-12 nopadding">
        <div class="nav-tabs-custom">
            <ul class="nav nav-tabs">
                <li class="<%=map.get("inc/opfactures")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/opfactures">Ordre de paiement factures</a></li>
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

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

