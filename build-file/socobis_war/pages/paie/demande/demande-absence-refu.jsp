
<%@page import="paie.employe.EmployeComplet"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageInsert"%>
<%@ page import="paie.demande.DemandeJustifications" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="historique.MapUtilisateur" %>
<%@ page import="user.UserEJB" %>

<%
    try {
        String titre = "Demande d&#39;absence refus&eacute;e";
        String iddm = request.getParameter("id");
        String classe = "paie.demande.DemandeJustifications";
        String apres = "paie/demande/demande-absence-fiche.jsp";
        DemandeJustifications d = new DemandeJustifications();
        d.setNomTable("demande_libcomplet");
        PageInsert pi = new PageInsert(d, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        
        

        pi.getFormu().getChamp("etatlib").setVisible(false);
        pi.getFormu().getChamp("heuredepart").setVisible(false);
        pi.getFormu().getChamp("heurearrive").setVisible(false);
        pi.getFormu().getChamp("numero").setVisible(false);
        pi.getFormu().getChamp("desce").setVisible(false);
        pi.getFormu().getChamp("observation").setVisible(false);
        pi.getFormu().getChamp("titre").setVisible(false);
        pi.getFormu().getChamp("idtypedemande").setVisible(false); 
        pi.getFormu().getChamp("horairenormal").setVisible(false);
        pi.getFormu().getChamp("idtypeabsence").setVisible(false);
        pi.getFormu().getChamp("refuser").setVisible(false);
        pi.getFormu().getChamp("idremplacents").setVisible(false);
        pi.getFormu().getChamp("nom").setVisible(false);
        pi.getFormu().getChamp("prenom").setVisible(false);
        pi.getFormu().getChamp("typeabsencelib").setAutre("readonly");
        pi.getFormu().getChamp("typeabsencelib").setLibelle("Type absence");
        pi.getFormu().getChamp("datedepart").setAutre("readonly");
        pi.getFormu().getChamp("datedepart").setLibelle("Date d&eacute;but");
        pi.getFormu().getChamp("datefin").setAutre("readonly");
        pi.getFormu().getChamp("datefin").setLibelle("Date fin");
        pi.getFormu().getChamp("dateretour").setAutre("readonly");
        pi.getFormu().getChamp("dateretour").setLibelle("Date retour");
        pi.getFormu().getChamp("duree").setAutre("readonly");
        pi.getFormu().getChamp("duree").setLibelle("Nombre De Jours"); 
        pi.getFormu().getChamp("daty").setAutre("readonly");
        pi.getFormu().getChamp("daty").setLibelle("Date saisie");
        pi.getFormu().getChamp("remarque").setAutre("readonly");
        pi.getFormu().getChamp("motif").setAutre("readonly");
        pi.getFormu().getChamp("matricule").setAutre("readonly");
        pi.getFormu().getChamp("personnel").setAutre("readonly");
        pi.getFormu().getChamp("annuler").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idSup").setVisible(false);
        pi.getFormu().getChamp("idpersonnel").setVisible(false);
        pi.getFormu().getChamp("superieur").setAutre("readonly");
        pi.getFormu().getChamp("superieur").setLibelle("Sup&eacute;rieur");
        pi.getFormu().getChamp("remplacents").setAutre("readonly");
        pi.getFormu().getChamp("remplacents").setLibelle("Remplacent");
        pi.getFormu().getChamp("ranguser").setVisible(false);
        pi.getFormu().getChamp("avenant").setVisible(false);
        pi.getFormu().getChamp("motifrefu").setLibelle("Motif de refus");
        if(iddm!=null && iddm.startsWith("DM"))
        {
            DemandeJustifications tmp = new DemandeJustifications();
            tmp.setNomTable("demande_libcomplet");
            tmp.setId(iddm);

            d = (DemandeJustifications) CGenUtil.rechercher(tmp,null,null," ")[0];

            UserEJB ue = (UserEJB) session.getValue("u");
            MapUtilisateur mapUser = ue.getUser();
            d.refuser(String.valueOf(mapUser.getRefuser()), null);
            pi.getFormu().setDefaut(d); 
        } 

        pi.preparerDataFormu();
        
       

        
%>
<div class="content-wrapper">
    <h1><%= titre %></h1>
    
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="nn" id="nn" >
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="daty" type="hidden" id="daty" value="<%=Utilitaire.dateDuJour()%>">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classe%>">
        <input name="nomtable" type="hidden" id="nomtable" value="Demande">
    </form>
</div>

<script>
    
    var textFields = document.querySelectorAll('input[type="text"]');
    var index = 0;
    for (index = 0; index < textFields.length; ++index) {
        var textField = textFields[index];
        textField.setAttribute("oninput", "this.value = this.value.toUpperCase()");
    }
    function champMontant(){
        let qual = $('#idqualification').val();
        let catpaie = $('#idcategorie_paie').val();
        
        if(qual && qual != "" && catpaie && catpaie != "" ){
            console.log('tairo!');
            $.ajax({
                type:'GET',
                url:'/fer/MontantInfoPers?idqualification='+qual+'&idcategorie_paie='+catpaie,
                contentType: 'text/html',
                success:function(ma){
                    var data = ma;   
                    console.log(data);
                    $('#montant_af').val(data);
                }
            });
            
        }else{
            console.log('mbola!');
        }
    }
</script>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>