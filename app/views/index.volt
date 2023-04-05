<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html>
<!--<![endif]-->
  {{ partial('partials/head') }}
  <body>
    <!--[if lt IE 7]>
      <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="#">upgrade your browser</a> to improve your experience.</p>
    <![endif]-->
    <table class="full-width" style="border-spacing: 0;">
      <tr>
        <td>
          {{ partial('partials/header') }}
          {{ content() }}
          {{ partial('partials/footer') }}
          {{ partial('partials/scripts') }}
        </td>
      </tr>
    </table>
  </body>
</html>
