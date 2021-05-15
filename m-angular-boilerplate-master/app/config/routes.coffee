Config.routes = [
  {
    url: "/"
    params:
      name: "home"
      label: "Home"
      templateUrl: "partials/home.html"
      controller: "HomeCtrl"
  }
  {
    url: "/about"
    params:
      name: "about"
      label: "About Us"
      templateUrl: "partials/about.html"
  }
]
