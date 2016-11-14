---
date: 2016-11-11T16:53:23Z
title: Getting started
weight: 20
---

## Installation and setup

### Get Hoverfly
Hoverfly is a single binary file. It comes with an optional command line interface tool called hoverctl.

Zip archives containing the Hoverfly and hoverctl binaries for Windows, MacOS and Linux are available on the GitHub releases page:

[Hoverfly & hoverctl zip archives](https://github.com/SpectoLabs/hoverfly/releases/latest)

Download the archive for your OS, extract the Hoverfly and hoverctl binaries and move them to a directory on your [PATH](https://www.java.com/en/download/help/path.xml).

#### Homebrew (MacOS)

```
brew install SpectoLabs/tap/hoverfly
```


### Run Hoverfly

To capture traffic between your application and an external service, you will need to configure your OS, browser or application to use Hoverfly as a proxy.

#### MacOS & Linux

Run Hoverfly using hoverctl:
```
hoverctl start
```

By default, the Hoverfly proxy runs on localhost:8500. Switch Hoverfly to "capture" mode and make a request with cURL, using Hoverfly as a proxy:
```
hoverctl mode capture
curl --proxy http://localhost:8500 http://hoverfly.io/
```

Hoverfly has captured the request and the response. View the Hoverfly logs:

```
hoverctl logs
```

Switch Hoverfly to "simulate" mode" and make the same request:
```
hoverctl mode simulate
curl --proxy http://localhost:8500 http://hoverfly.io/
```
Hoverfly has returned the captured response.

#### Windows

Open a command prompt and run Hoverfly using hoverctl:
```
hoverctl start
```

Configure your application, browser or OS to use the Hoverfly proxy (http://localhost:8500). Switch Hoverfly to "capture" mode:

```
hoverctl mode capture
```

Make some requests from your application, browser or OS, then view the Hoverfly logs:

```
hoverctl logs
```

Switch Hoverfly to "simulate" mode:

```
hoverctl mode simulate
```

Make the same requests from your browser, OS or application. Hoverfly is returning the captured responses.

More information on proxy settings:

* [Windows proxy settings explains](http://blog.raido.be/?p=426)
* [Firefox proxy settings](https://support.mozilla.org/en-US/kb/advanced-panel-settings-in-firefox#w_connection)
* [Java Networking and Proxies](https://docs.oracle.com/javase/6/docs/technotes/guides/net/proxies.html)

### Docker image

The Hoverfly docker image contains only the Hoverfly binary.

    docker run -d -p 8888:8888 -p 8500:8500 spectolabs/hoverfly

The port mapping is for the Hoverfly AdminUI/API and proxy respectively. The Docker image supports Hoverfly flags (see **Flags and environment variables** in the **Usage** section).

### JUnit rule

The Hoverfly JUnit rule is available as a Maven dependency. To get started, add the following to your pom.xml:

    <groupId>io.specto</groupId>
    <artifactId>hoverfly-junit</artifactId>
    <version>0.1.4</version>

This will download the JUnit rule and the Hoverfly binary. More information on how to use the Hoverfly JUnit rule is available here:

[Easy API Simulation with the Hoverfly JUnit Rule](https://specto.io/blog/hoverfly-junit-api-simulation.html)         


### Setting the HOVERFLY_HOST environment variable

Throughout the documentation, `${HOVERFLY_HOST}` is used in API examples and Admin UI guides. If you are running a binary on your local machine, the Hoverfly host will be `localhost`. However, if you are running Hoverfly on a remote machine, or using Docker Machine for example, it will be different.

To make things easier when following the documentation, it is recommended that you set the HOVERFLY_HOST environment variable. For example:

    export HOVERFLY_HOST=localhost

### Hoverfly as an HTTP(S) proxy

Hoverfly is primarily a proxy - although it can run (with limitations) as a webserver. To use Hoverfly in your development or test environment to capture traffic, you need to ensure that your application is using it as a proxy. This can be done at the OS level, or at the application level, depending on the environment.


### Admin UI

The Hoverfly Admin UI is available on port 8888 by default:

    http://${HOVERFLY_HOST}:8888

The port is configurable (see the **Flags and environment variables** section).

When authentication is disabled (which is the default), you can use **any username and password combination** to access the Admin UI.

The Admin UI can be used to change the Hoverfly mode, and to view basic analytic information. It uses the Hoverfly API.

## Use cases

Hoverfly is designed to cater for two high-level use cases.

#### Capturing real HTTP(S) traffic between an application and an external service for re-use in testing or development.

If the external service you want to simulate already exists, you can put Hoverfly in between your client application and the external service. Hoverfly can then capture every request from the client application and every matching response from the external service (*capture mode*).

These request/response pairs are persisted in Hoverfly, and can be exported to a service data JSON file. The service data file can be stored elsewhere (a Git repository, for example), modified as required, then imported back into Hoverfly (or into another Hoverfly instance).

Hoverfly can then act as a "surrogate" for the external service, returning a matched response for every request it received (*simulate mode*).

This is useful if you want to create a portable, self-contained version of an external service to develop and test against.

This could allow you to get around the problem of rate-limiting (which can be frustrating when working with a public API).

You can write Hoverfly extensions to manipulate the data in pre-recorded responses, or to simulate network latency.

You could work while offline, or you could speed up your workflow by replacing a slow dependency with a fast Hoverfly "surrogate".

More information on these use-cases is available here:

* [Creating fast versions of slow dependencies](http://www.specto.io/blog/speeding-up-your-slow-dependencies.html)
* [Virtualizing the Meetup API](http://www.specto.io/blog/hoverfly-meetup-api.html)


#### Creating simulated services for use in a testing or development.

In some cases, the external service you want to simulate might not exist yet.

You can create service simulations by writing service data JSON files. This is in line with the principle of [design by contract](https://en.wikipedia.org/wiki/Design_by_contract) development.

Service data files can be created by each developer, then stored in a Git repository. Other developers can then import the service data directly from the repository URL, providing them with a Hoverfly "surrogate" to work with.

Instead of writing a service data file, you could write a "middleware" script for Hoverfly that generates a response "on the fly", based on the request it receives (*synthesize mode*).  

More information on this use-case is available here:

* [Synthetic service example](https://github.com/SpectoLabs/hoverfly/tree/master/examples/middleware/synthetic_flight_search)
* [Easy API simulation with the Hoverfly JUnit rule](https://specto.io/blog/hoverfly-junit-api-simulation.html)

Proceed to the **"Modes" and middleware** section to understand how Hoverfly is used in these contexts.

## Modes and middleware

### Hoverfly modes

Hoverfly has four modes. Detailed guides on how to use these modes are available in the **Usage** section.

#### Capture mode

![](hf_capture.png)

In this mode, Hoverfly acts as a proxy between the client application and the external service. It transparently intercepts and stores out-going requests from the client and matching incoming responses from the external service.

This is how you capture real traffic for use in development or testing.

#### Simulate mode

![](hf_simulate.png)

In this mode, Hoverfly uses either previously captured traffic, or imported service data files to mimic the external service.

This is useful if you are developing or testing an application that needs to talk to an external service that you don't have reliable access to. You can use the Hoverfly "surrogate" instead of the real service.

#### Synthesize mode

![](hf_synthesize.png)

In this mode, Hoverfly doesn't use any stored request/response pairs. Instead, it generates responses to incoming requests on the fly and returns them to the client. This mode is dependent on *middleware* (see below) to generate the responses.

This is useful if you can't (or don't want to) capture real traffic, or if you don't want to write service data files.

#### Modify mode

![](hf_modify.png)

In this mode, Hoverfly passes requests through from the client to the server, and passes the responses back. However, it also executes middleware on the requests and responses.

This is useful for all kinds of things such as manipulating the data in requests and/or responses on the fly.

### Middleware

Middleware can be written in any language, as long as that language is supported by the Hoverfly host. For example, you could write middleware in Go, Python or JavaScript (if you have Go, Python or NodeJS installed on the Hoverfly host, respectively).

Middleware is applied to the requests and/or the responses depending on the mode:

* Capture Mode: middleware affects only outgoing requests
* Simulate Mode: middleware affects only responses (cache contents remain untouched)
* Synthesize Mode: middleware creates responses
* Modify Mode: middleware affects requests and responses

Middleware can be used to do many useful things, such as simulating network latency or failure, rate limits or controlling data in requests and responses.

A detailed guide on how to use middleware is available in the **Usage** section.

## Server type
While Hoverfly is primarily a proxy, there are some situations in which you may need to run it as a webserver - for example if setting the host OS or application to use a proxy is not possible or desirable.

Currently, when running as a webserver, Hoverfly can only be set to *simulate* mode. This is useful if you have a simulation that has been created by capturing traffic using a Hoverfly instance running as a proxy, and you want to import and run it in an environment which cannot be configured to use a proxy.

### Starting Hoverfly as a webserver
If you are using hoverctl to manage your instance of Hoverfly, you can start Hoverfly as a webserver using hoverctl.
```
hoverctl start webserver
```

If you are running the Hoverfly binary, you can specify the webserver flag which will start Hoverfly as a webserver.
```
./hoverfly -webserver
```

**NOTE:** Currently HTTPS is not supported when running Hoverfly as a webserver. HTTPS support when running as a webserver is on the roadmap.

### Simulations and request matching
When running as a webserver, although Hoverfly functionality is limited to simulate mode, Hoverfly still uses the standard simulations.

When Hoverfly is running as a webserver, the server is available on the same port as the proxy. When you make requests to the webserver, responses will be matched in the same way as with the proxy, except the host will be disregarded. This means that if you have a simulation with multiple hosts, they will all be served from the same host.
