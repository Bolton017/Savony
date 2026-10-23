<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="ordredepaiement.OrdreDePaiement" %>
<%@ page import="affichage.Liste"%>
<%@ page import="faturefournisseur.ModePaiement" %>
<%@ page import="faturefournisseur.FactureFournisseurCpl" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "ordredepaiement.OrdreDePaiement";
    String nomTable = "ORDREDEPAIEMENT";
    String apres = "ordredepaiement/ordredepaiement-fiche.jsp";

    String idF = request.getParameter("idFournisseur");
    if (idF == null || idF.trim().isEmpty()) {
        throw new Exception("Aucun fournisseur n'a été sélectionné pour le paiement.");
    }
    String[] idFacts = request.getParameterValues("ids");
    FactureFournisseurCpl[] factureFournisseurs = null;
    double montantTotal = 0.0;
    String idFactsStr = "";
    if(idFacts != null && idFacts.length > 0){
        factureFournisseurs = new FactureFournisseurCpl[idFacts.length];
        for(int i=0; i<idFacts.length; i++){
            factureFournisseurs[i] = (FactureFournisseurCpl) new FactureFournisseurCpl().getById(idFacts[i], "FACTUREFOURNISSEURCPL", null);
            idFactsStr += idFacts[i];
            if(i < idFacts.length-1){
                idFactsStr += ";";
            }
            montantTotal += factureFournisseurs[i].getMontantreste();
        }
    }
    else {
        throw new Exception("Aucune facture n'a été sélectionnée pour le paiement.");
    }

    OrdreDePaiement o = new OrdreDePaiement();
    o.setNomTable("ORDREDEPAIEMENT");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un ordre de paiement de factures");

    Liste[] liste = new Liste[1];
    ModePaiement liste0 = new ModePaiement();
    liste0.setNomTable("MODEPAIEMENT");
    liste[0] = new Liste("modepaiement",liste0,"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("idfacts").setDefaut(idFactsStr);
    pi.getFormu().getChamp("montant").setDefaut(montantTotal+"");
    pi.getFormu().getChamp("tiers").setDefaut(idF);
    pi.getFormu().getChamp("iduser").setDefaut(u.getUser().getTuppleID());
    pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());

    pi.getFormu().getChamp("idfacts").setLibelle("Factures");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("montant").setLibelle("Montant total");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("numeroop").setLibelle("Num&eacute;ro OP");
    pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
    pi.getFormu().getChamp("tiers").setLibelle("Fournisseur");
    pi.getFormu().getChamp("idfacts").setAutre("readonly");
    pi.getFormu().getChamp("montant").setAutre("readonly");
    pi.getFormu().getChamp("tiers").setAutre("readonly");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("iduser").setVisible(false);
    pi.getFormu().getChamp("tiers").setPageAppelComplete("faturefournisseur.Fournisseur","id","FOURNISSEUR","","");

    String[] ordre = {"idfacts","daty","montant","remarque","numeroop","modepaiement","tiers"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un ordre de paiement de factures");
    }

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

