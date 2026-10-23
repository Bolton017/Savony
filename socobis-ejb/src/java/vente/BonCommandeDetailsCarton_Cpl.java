package vente;

public class BonCommandeDetailsCarton_Cpl extends BonDeCommandeFille{

    private double restecf,quantitecf, quantitebf;

 public BonCommandeDetailsCarton_Cpl()throws Exception{
    super();
        this.setNomTable("BonCommandeDetailsCarton_Cpl");
    }
   

   public void setRestecf(double restecf){
        this.restecf = restecf;
   }


   public void setQuantitecf(double quantitecf){
        this.quantitecf = quantitecf;
   }
   
   public void setQuantitebf(double quantitebf){
        this.quantitebf = quantitebf;
   }
   
   public double getRestecf(){
    return this.restecf;
   }
   public double getQuantitecf(){
        return this.quantitecf;
   }

   public double getQuantitebf(){
        return this.quantitebf;
   }

}