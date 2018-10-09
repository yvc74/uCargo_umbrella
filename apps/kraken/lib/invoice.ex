defmodule Kraken.Invoice do
  @moduledoc """
  Module for create invoices
  """
  require Logger

  def generate(payment) do
    response = perform_generate_request(payment)
    case HTTPotion.Response.success?(response) do
      true ->
        {:ok, Jason.decode!(response.body)}
      false ->
        Logger.info("inspect #{response.body}")
        {:error, "Error in request from factura gorila"}
    end
  end

  def download_xml(document_id) do
    response = perform_download_document_request(document_id, "xml")
    case HTTPotion.Response.success?(response) do
      true ->
        {:ok, Jason.decode!(response.body)}
      false ->
        Logger.info("inspect #{response.body}")
        {:error, "Error in download xml from factura gorila"}
    end
  end

  def download_pdf(document_id) do
    response = perform_download_document_request(document_id, "pdf")
    case HTTPotion.Response.success?(response) do
      true ->
        {:ok, Jason.decode!(response.body)}
      false ->
        Logger.info("inspect #{response.body}")
        {:error, "Error in download xml from factura gorila"}
    end
  end

  defp perform_download_document_request(document_id, type) do
    headers = ["Content-Type": "application/json",
              "Authorization": "YnN4dGVzdEBiaXNpbXBsZXguY29tOmJpc2ltcGxleA==",
              "ApiKey": "65wMxa10CSFW6XmO9oL8JPHQrv7m/ElNS7Y0/6nkeYymNzquaIZtPUBI1mN2pmk/e2pyEGAGdJM="]
    HTTPotion.get(
      "https://test.facturagorila.com/v2/api/documentos/#{document_id}/#{type}",
      headers: headers,
      timeout: 10_000
    )
  end


  defp perform_generate_request(payment) do
    headers = ["Content-Type": "application/json",
              "Authorization": "YnN4dGVzdEBiaXNpbXBsZXguY29tOmJpc2ltcGxleA==",
              "ApiKey": "65wMxa10CSFW6XmO9oL8JPHQrv7m/ElNS7Y0/6nkeYymNzquaIZtPUBI1mN2pmk/e2pyEGAGdJM="]
    body = invoice_body(payment)
    HTTPotion.post(
      "https://test.facturagorila.com/v2/api/documentos/Crear/Simple",
      body: Jason.encode!(body),
      headers: headers,
      timeout: 10_000
    )
  end

  defp invoice_body(payment) do
    %{
      "Borrador": false,
      "Conceptos": [
        %{
          "Cantidad": 1.0,
          "ConceptoId": "3",
          "Descripcion": "Descripción del concepto 1",
          "Descuento": 0,
          "Precio": payment.amount,
          "Predial": ""
        }
      ],
      "CondicionesPago": "",
      "CorreoElectronico": "jorge.rdz@bisimplex.com",
      "Fecha": Timex.format!(Timex.now("America/Chicago"), "%Y-%m-%d", :strftime),
      "FormaPago": "01",
      "MetodoPago": "PUE",
      "Moneda": "MXN",
      "Notas": "Estas son las notas para el cliente",
      "RegimenFiscal": "601",
      "ResidenciaFiscal": "MEX",
      "SucursalId": "96",
      "TipoCambio": 1,
      "TipoDocumentoId": 1,
      "UsoCFDI": "G01",
      "ReceptorId": "15"
    }
  end
end

