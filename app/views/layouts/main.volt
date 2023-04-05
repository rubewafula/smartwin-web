<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->

<html class="no-js">
<!--<![endif]-->
    {{ partial('partials/head') }}
    <body>
    <!--[if lt IE 7]>
      <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="#">upgrade your browser</a> to improve your experience.</p>
    <![endif]-->
        {{ partial('partials/header') }}
        {{ content() }}
        {{ partial('partials/footer') }}

        $(document).ready(function () {
                console.log("Running docunet dot somethging ");
                $('.carousel').carousel({
                  interval: 2000
                });

        })
    </body>
</html>
