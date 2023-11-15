package webapp

import (
	gsl "greymatter.io/gsl/v1"

	"webapp.module/greymatter:globals"
)


Webapp_Service: gsl.#Service & {
	// A context provides global information from globals.cue
	// to your service definitions.
	context: Webapp_Service.#NewContext & globals

	// name must follow the pattern namespace/name
	name:          "webapp-service"
	display_name:  "Webapp Webapp Service"
	version:       "v1.0.0"
	description:   "EDIT ME"
	api_endpoint:              "https://\(context.globals.edge_host)/services/\(context.globals.namespace)/\(name)/"
	api_spec_endpoint:         "https://\(context.globals.edge_host)/services/\(context.globals.namespace)/\(name)/"
	
	business_impact:           "low"
	owner: "Webapp"
	capability: ""
	health_options: {
		tls: gsl.#MTLSUpstream
	}
	// Webapp-Service -> ingress to your container
	ingress: {
		(name): {
			gsl.#HTTPListener
			gsl.#MTLSListener
			
			//  NOTE: this must be filled out by a user. Impersonation allows other services to act on the behalf of identities
			//  inside the system. Please uncomment if you wish to enable impersonation. If the servers list if left empty,
			//  all traffic will be blocked.
			//	filters: [
			//    gsl.#ImpersonationFilter & {
			//		#options: {
			//			servers: ""
			//			caseSensitive: false
			//		}
			//    }
			//	]
			routes: {
				"/": {
					
					upstreams: {
						"local": {
							gsl.#Upstream
							
							instances: [
								{
									host: "127.0.0.1"
									port: 80
								},
							]
						}
					}
				}
			}
		}
	}


	
	// Edge config for the Webapp-Service service.
	// These configs are REQUIRED for your service to be accessible
	// outside your cluster/mesh.
	edge: {
		edge_name: "edge"
		routes: "/services/\(context.globals.namespace)/\(name)": {
			prefix_rewrite: "/"
			upstreams: (name): {
				gsl.#Upstream
				namespace: context.globals.namespace
				gsl.#MTLSUpstream
			}
		}
	}
	
}

exports: "webapp-service": Webapp_Service
