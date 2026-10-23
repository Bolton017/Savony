<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="opfacture.OpFactureSaisie" %>
<%@ page import="affichage.Liste" %>
<%@ page import="caisse.Caisse" %>

<% try{
    UserEJB u = (user.UserEJB) session.getAttribute("u");
    String mapping = "opfacture.OpFactureSaisie";
    String nomTable = "OPFACTURESAISIE";
    String idOrdre = request.getParameter("idOrdre");
    String apres = "ordredepaiement/ordredepaiement-fiche.jsp";

    OpFactureSaisie o = new OpFactureSaisie();
    o.setIdop(idOrdre);
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getAttribute("lien"));
    pi.setTitre("");
    OpFactureSaisie defaut = o.getOpFactureByidOp();
    Liste[] listes = new Liste[1];
    listes[0] = new Liste("idCaisse", new Caisse(),"val", "id");
    pi.getFormu().changerEnChamp(listes);
    pi.getFormu().getChamp("idCaisse").setLibelle("Caisse");
    pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("idfacture").setLibelle("Factures");
    pi.getFormu().getChamp("montant").setLibelle("Montant");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idop").setVisible(false);
    pi.getFormu().getChamp("idfacture").setAutre("readonly");
    pi.getFormu().getChamp("montant").setAutre("readonly");
    pi.getFormu().getChamp("montant").setDefaut(String.valueOf(defaut.getMontant()));
    pi.getFormu().getChamp("designation").setDefaut(defaut.getDesignation());
    pi.getFormu().getChamp("idfacture").setDefaut(defaut.getIdfacture());
    pi.getFormu().getChamp("idop").setDefaut(defaut.getIdop());

    String[] ordre = {"idCaisse","designation","idop","idfacture","montant","daty","etat"};
    pi.getFormu().setOrdre(ordre);

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
