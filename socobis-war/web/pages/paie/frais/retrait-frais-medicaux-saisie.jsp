<%@page import="java.math.BigDecimal"%>
<%@page import="paie.log.LogPersonnelFraisMedicaux"%>
<%@page import="paie.conge.Absence"%>
<%@page import="paie.log.LogPersonnelFin"%>
<%@page import="utils.ConstantePaie"%>
<%@page import="paie.frais.RetraitFraisMedicaux"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@page import="affichage.PageInsert"%>
<%
    try {
        
    RetraitFraisMedicaux cp = new RetraitFraisMedicaux();
    cp.setNomTable("retrait_frais_medicaux_reste");
    user.UserEJB u = (user.UserEJB) session.getValue("u");
    boolean dg = u.getUser().getIdrole().equals(ConstantePaie.idRoleDg);
    PageInsert pi = new PageInsert(cp, request, u);
    pi.setLien((String) session.getValue("lien"));
    
    pi.getFormu().getChamp("idpersonnel").setDefaut(u.getUser().getTeluser());
    pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("description").setLibelle("Description");
    pi.getFormu().getChamp("montant").setLibelle("Montant demand&eacute;");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("daty").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pi.getFormu().getChamp("idpersonnel").setPageAppel("choix/logPersonnelChoixFraisMedicaux.jsp","idpersonnel;idpersonnellibelle;reste");
    pi.getFormu().getChamp("reste").setLibelle("Solde");
    pi.getFormu().getChamp("reste").setAutre("readonly");
    
    pi.getFormu().getChamp("idpersonnel").setAutre("readonly");
    pi.getFormu().getChamp("etat").setVisible(false);
    
    LogPersonnelFraisMedicaux pip = LogPersonnelFraisMedicaux.getInfoPersonnel(u.getUser().getLoginuser() );
    if(pip != null){
        pi.getFormu().getChamp("reste").setDefaut(new BigDecimal(pip.getReste_frais_medicaux()).toPlainString());
    } 
    
    pi.preparerDataFormu();
    
%>
<style>
        .error {
            background-color: rgba(255, 0, 0, 0.3);
        }
    </style>
<div class="content-wrapper">
    <h1 align="center">Demande de remboursement</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="sortie" id="sortie" data-parsley-validate>
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %> 
        <input name="acte" type="hidden" id="acte" value="insert">
        <input name="bute" type="hidden" id="bute" value="paie/frais/retrait-frais-medicaux-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="mg.fer.paie.RetraitFraisMedicaux">
        <input name="nomtable" type="hidden" id="nomtable" value="retrait_frais_medicaux">
    </form>
</div>
<script>
    const montantDemandeInput = document.getElementById("montant");
    
    <% if(!dg){ %>
        $('#idpersonnel').parent().parent().find('input[type="button"]').remove();
    <% } %>    
    $('#idpersonnellibelle').val('<%= u.getUser().getNomuser() %>');

    function verifierMontant() {
        const montant = parseFloat(document.getElementById('montant').value) || 0;
        const reste = parseFloat(document.getElementById('reste').value) || 0;
        const inputMontant = document.getElementById('montant');

        if (montant > reste) {
            inputMontant.classList.add('error'); 
        } else {
            inputMontant.classList.remove('error'); 
        }
    }

    document.getElementById('montant').addEventListener('input', verifierMontant);
</script>       
<%                    
        } catch (Exception e) {
       e.printStackTrace();
       throw e;
}
%>
