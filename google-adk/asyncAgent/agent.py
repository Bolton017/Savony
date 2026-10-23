from google.adk.agents import LlmAgent
from google.adk.tools import google_search
ocr_agent = LlmAgent(
    model="gemini-2.0-flash-exp",
    name="ocr_agent",
    instruction="""All you do is scan a receipt and give me the 
    JSON Response:
    {
        "daty" : "date formatted as dd/mm/yyyy",
		"idOrigine" : "the exact name of the provider"
		"idMagasin" : "the location of the delivery"
		"designation" "title of the receipt"
		"type" : "BC for bon de commande (sale) or FF for facture fournisseur (purchase)"
		"details" : "array of each detail" [{
            "idProduit"
            "qte is a double number"
            "pu is a double number"
		}]
			
    }
    , in Malagasy """,
    description="Malagasy ocr agent",
    tools=[],
)
root_agent = LlmAgent(
    name="asyncAgent",
    model="gemini-2.0-flash-exp",
    instruction=(
        f"""Use {ocr_agent}"""
    ),
    sub_agents=[ocr_agent],
)