"""
Personator Consumer verifies, corrects and appends contact data (name, address, phone,
email) for a consumer record. This sample sends a US address and asks for a "check"
with geocode columns, returning the standardized address, its Melissa Address Key (MAK)
and latitude/longitude.

High-level flow of this sample:
  1. ARGS    - main reads any --flag values off the command line with argparse.
  2. INPUT   - call_api fills in whatever wasn't supplied via interactive prompts.
  3. REQUEST - call_api builds the REST query string (license + fixed action/columns
               + input fields).
  4. CALL    - get_contents issues the GET request and pretty-prints the JSON response.

This sample is a thin HTTP client: it builds a query string, sends a GET request to
the Personator Consumer Cloud API, and prints the JSON response.

Reference:
  - Documentation: https://docs.melissa.com/cloud-api/personator-consumer/personator-consumer-index.html
  - Release notes: https://releasenotes.melissa.com/cloud-api/personator-consumer/
  - Result codes:  https://docs.melissa.com/melissa/result-codes/result-codes-index.html
"""

import json
import requests
import argparse
import urllib.parse

def main():
  """
  Entry point. Reads the optional command-line arguments, then hands control to
  call_api, which performs the actual request/response cycle.

  Recognized flags (each followed by its value, e.g. --city "Rancho Santa Margarita"):
  --license/-l, --addressline1, --city, --state, --postal, --country.
  Any flag not supplied is None, and call_api prompts for it interactively.
  """
  base_service_url = "https://personator.melissadata.net/"
  service_endpoint = "v3/WEB/ContactVerify/doContactVerify"; #please see https://www.melissa.com/developer/personator for more endpoints

  # Create an ArgumentParser object
  parser = argparse.ArgumentParser(description='Personator Consumer command line arguments parser')

  # Define the command line arguments
  parser.add_argument('--license', '-l', type=str, help='License key')
  parser.add_argument('--addressline1', type=str, help='Address Line 1')
  parser.add_argument('--city', type=str, help='City')
  parser.add_argument('--state', type=str, help='State')
  parser.add_argument('--postal', type=str, help='Postal Code')
  parser.add_argument('--country', type=str, help='Country')

  # Parse the command line arguments
  args = parser.parse_args()

  # Access the values of the command line arguments
  license = args.license
  addressline1 = args.addressline1
  city = args.city
  state = args.state
  postal = args.postal
  country = args.country

  # Run the lookup with whatever values were passed on the command line.
  call_api(base_service_url, service_endpoint, license, addressline1, city, state, postal, country)

def get_contents(base_service_url, request_query):
    """
    Issues the GET request against the Personator Consumer endpoint and pretty-prints
    the API call and the JSON response to the console.

    Args:
        base_service_url: The Personator Consumer Cloud API base URL.
        request_query: The endpoint path plus query string built by call_api.
    """
    url = urllib.parse.urljoin(base_service_url, request_query)
    response = requests.get(url)

    # Re-serialize with indentation so the raw response is easier to read.
    obj = json.loads(response.text)
    pretty_response = json.dumps(obj, indent=4)

    print("\n==================================== OUTPUT ====================================\n")

    print("API Call: ")
    for i in range(0, len(url), 70):
        if i + 70 < len(url):
            print(url[i:i+70])
        else:
            print(url[i:len(url)])
    print("\nAPI Response:")
    print(pretty_response)

def call_api(base_service_url, service_endpoint, license, addressline1, city, state, postal, country):
    """
    Drives the interactive/CLI loop: gathers the required address fields, builds and
    submits the REST query, prints the result, and optionally repeats for another record.

    It runs a single pass and exits only when every address field was supplied on the
    command line. Otherwise it loops, asking for a new record each pass until the user
    answers "N".

    Args:
        base_service_url: The Personator Consumer Cloud API base URL.
        service_endpoint: The specific Personator Consumer endpoint path to call.
        license: The Melissa license string sent with every request.
        addressline1: A street address to test, or None to prompt for it.
        city: A city to test, or None to prompt for it.
        state: A state to test, or None to prompt for it.
        postal: A postal code to test, or None to prompt for it.
        country: A country to test, or None to prompt for it.
    """
    print("\n=============== WELCOME TO MELISSA PERSONATOR CONSUMER CLOUD API ===============\n")

    should_continue_running = True
    while should_continue_running:
        input_addressline1 = ""
        input_city = ""
        input_state = ""
        input_postal = ""
        input_country = ""

        # No address values were supplied via command line, so prompt for every field.
        if not addressline1 and not city and not state and not postal and not country:
            print("\nFill in each value to see results")
            input_addressline1 = input("Addressline1: ")
            input_city = input("City: ")
            input_state = input("State: ")
            input_postal = input("Postal: ")
            input_country = input("Country: ")

        else:
            # At least one address field was supplied via command line; use those values as-is.
            input_addressline1 = addressline1
            input_city = city
            input_state = state
            input_postal = postal
            input_country = country

        # Prompt individually for any still-missing required field.
        while not input_addressline1 or not input_city or not input_state or not input_postal or not input_country:
            print("\nFill in each value to see results")
            if not input_addressline1:
                input_addressline1 = input("\nAddressline1: ")
            if not input_city:
                input_city = input("\nCity: ")
            if not input_state:
                input_state = input("\nState: ")
            if not input_postal:
                input_postal = input("\nPostal: ")
            if not input_country:
                input_country = input("\nCountry: ")

        # Map input fields to the API's expected query parameter names. The request
        # always asks for a JSON response, the "check" action, and the GrpGeocode
        # column group (latitude/longitude and related geocode fields).
        inputs = {
            "format": "json",
            "act": "check",
            "cols": "GrpGeocode",
            "a1": input_addressline1,
            "city": input_city,
            "state": input_state,
            "postal": input_postal,
            "ctry": input_country,
        }

        print("\n==================================== INPUTS ====================================\n")
        print(f"\t   Base Service Url: {base_service_url}")
        print(f"\t  Service End Point: {service_endpoint}")
        print(f"\t       Addressline1: {input_addressline1}")
        print(f"\t               City: {input_city}")
        print(f"\t              State: {input_state}")
        print(f"\t        Postal Code: {input_postal}")
        print(f"\t            Country: {input_country}")

       # Create Service Call
        # Set the License String in the Request
        rest_request = f"&id={urllib.parse.quote_plus(license)}"

        # Set the Input Parameters
        for k, v in inputs.items():
            rest_request += f"&{k}={urllib.parse.quote_plus(v)}"

        # Build the final REST String Query
        rest_request = service_endpoint + f"?{rest_request}"

        # Submit to the Web Service.
        success = False
        retry_counter = 0

        while not success and retry_counter < 5:
            try: #retry just in case of network failure
                get_contents(base_service_url, rest_request)
                print()
                success = True
            except Exception as ex:
                retry_counter += 1
                print(ex)
                return

        is_valid = False

        # If every address field came from the command line, treat this as a one-shot
        # run rather than looping for additional records.
        if (addressline1 is not None) and (city is not None) and (state is not None) and (postal is not None) and (country is not None):
            concat = addressline1 + city + state + postal + country
        else:
            concat = None

        if concat is not None and concat != "":
            is_valid = True
            should_continue_running = False

        # Otherwise ask whether to test another record. Keep prompting until we get a
        # valid Y/N. "N" ends the program; "Y" falls through to another pass.
        while not is_valid:
            test_another_response = input("\nTest another record? (Y/N)")
            if test_another_response != '':
                test_another_response = test_another_response.lower()
                if test_another_response == 'y':
                    is_valid = True
                elif test_another_response == 'n':
                    is_valid = True
                    should_continue_running = False
                else:
                    print("Invalid Response, please respond 'Y' or 'N'")

    print("\n===================== THANK YOU FOR USING MELISSA CLOUD API ====================\n")

main()
