<%-- 
    Document   : apresCommandeFait
    Created on : 16 sept. 2019, 09:31:13
    Author     : pro
--%>

<%@page import="produits.Recette"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="user.UserEJB"%>
<%@page contentType="text/html" pageEncoding="ISO-8859-1"%>

<%
    
    UserEJB u = (UserEJB) session.getAttribute("u");
    String[] id = request.getParameterValues("id");
    String[] remarque = request.getParameterValues("remarque");
    String lien = (String) session.getValue("lien");
    String acte = request.getParameter("acte");
    String bute = request.getParameter("bute");
    String caisse=request.getParameter("caisse");
        if(acte != null && !"".equals(acte) && acte.equals("modifier_recette")){
        Recette rec=new Recette(); 
        rec.modifQte(String.valueOf(u.getUser().getRefuser()),id,request.getParameterValues("quantite") ,null);
    }
        if(acte != null && !"".equals(acte) && acte.equals("supprimer_recette")){
          Recette rec=new Recette();
//          if (!u.getUser().getLoginuser().equalsIgnoreCase("narindra") && !u.getUser().getLoginuser().equalsIgnoreCase("Baovola"))
//            {
//                 throw new Exception ("Modification non autoris\\351");
//            }
          rec.suppressionMultiple(id,""+u.getUser().getRefuser() , null);
    }
         if(acte != null && !"".equals(acte) && acte.equals("achat")){
             
             String[] aacheter = request.getParameterValues("aacheter");
             String[] pu = request.getParameterValues("pu");
             String[] idfournisseur=request.getParameterValues("idFournisseur");
            
//             EtatdeStockDate.insertAchat(id,idfournisseur,pu,aacheter,u.getUser().getTuppleID(),null);
    }
           if(acte != null && !"".equals(acte) && acte.equals("voaraycuisinier")){
//            CommandeClientDetails.commandeVoarayCuisinierMultiple(request.getParameterValues("id"),null,u);
            bute="commande/as-commande-liste-details.jsp";
    }
         
         
      
   
       
//    if(acte != null && !"".equals(acte) && acte.equals("annuler_boisson")) u.annulerDetailsCommande(id);
        //cs.annulerBoisson(id, null);
//    if(acte != null && !"".equals(acte) && acte.equals("modifier"))
//        cs.modifRemarque(id, remarque, null);
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>