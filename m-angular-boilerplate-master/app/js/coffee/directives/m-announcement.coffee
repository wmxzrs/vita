###*
 @ngdoc directive
 @name m-directive.directive:mAnnoucement
 @element div
 @restrict AE
 @description This directive is used to create `annoucements`,
 @example
  <example module="eg">
    <file name="index.js">
      angular.module('eg',['ui.bootstrap', 'm-directive'])
        .controller('EgCtrl', ['$scope', function($scope){
          $scope.anns = [{
            date: "2014-01-01",
            msg: "this is a test"
          }];
        }]);
    </file>
    <file name="index.html">
      <div ng-controller="EgCtrl">
        <m-announcement announcements="anns"></m-announcement>
      </div>
    </file>
  </example>
###
angular.module('m-directive').directive 'mAnnouncement', ($uibPosition) ->
  restrict : 'AE'
  scope:
    announcements: '='
  template : """
              <span ng-show="show">
              <i class="fa fa-bullhorn animated infinite"
                 ng-class="{flash:flash}"></i>
              <div class="popover right fade in"
                style="transform:translateY(-40%);word-break:break-word;">
                <div class="arrow" style="top:90%"></div>
                <div class="popover-inner">
                <h3 class="popover-title" ng-bind="title" ng-show="title"></h3>
                <div class="popover-content">
                  <alert ng-repeat="a in announcements"
                    type="{{a.type || 'success'}}"
                    style="margin:3px;padding:2px">
                    <p>
                      <div class="label label-primary"
                        style="margin-right:5px">
                        {{a.date | date:'yyyy-MM-dd HH:mm:ss'}}
                      </div>
                      <div style="margin-left:5px">{{a.msg}}</div>
                    </p>
                  </alert>
                </div>
                </div>
              </div>
              </span>
           """
  controller: ($scope) ->
    cacheKey = 'viewed_annoucement_date'
    $scope.$watch 'announcements', (newVal, oldVal)->
      if newVal && newVal.length
        $scope.show = true
        first = newVal[0]
        if new Date(first.date) > new Date(localStorage.getItem cacheKey)
          $scope.flash = true
        localStorage.setItem cacheKey, first.date
    , true

    $scope.stopFlash = ->
      $scope.flash = false

  link : (scope, element, attrs) ->
    icon = element.find 'i'
    list = element.find 'div'
    if list.length
      list = angular.element list[0]

    scope.title = attrs.title || 'Announcements'

    element.bind 'mouseenter', ->
      scope.$apply scope.stopFlash

      list.css 'display', 'block'
      ttPosition = $uibPosition.positionElements icon, list
      , attrs.placement || 'right'
      ttPosition.top += 'px'
      ttPosition.left += 'px'
      list.css ttPosition
    element.bind 'mouseleave', ->
      list.css 'display', 'none'

    scope.$on '$destroy', ->
      element.unbind 'mouseenter'
      element.unbind 'mouseleave'
