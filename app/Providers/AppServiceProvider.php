<?php

namespace App\Providers;

use App\Models\EmailConfiguration;
use App\Models\GeneralSetting;
use App\Models\LogoSetting;
use App\Models\PusherSetting;
use Illuminate\Pagination\Paginator;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\View;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        Paginator::useBootstrap();

        // If we are running during build, config:cache, route:cache, view:cache 
        // → do NOT run DB queries
        if (app()->runningInConsole()) {
            return;
        }

        try {
            $generalSetting = GeneralSetting::first();
            $logoSetting = LogoSetting::first();
            $mailSetting = EmailConfiguration::first();
            $pusherSetting = PusherSetting::first();
        } catch (\Exception $e) {
            // If database is still not ready
            return;
        }

        /** set time zone */
        Config::set('app.timezone', $generalSetting->time_zone);

        /** Set Mail Config */
        Config::set('mail.mailers.smtp.host', $mailSetting->host);
        Config::set('mail.mailers.smtp.port', $mailSetting->port);
        Config::set('mail.mailers.smtp.encryption', $mailSetting->encryption);
        Config::set('mail.mailers.smtp.username', $mailSetting->username);
        Config::set('mail.mailers.smtp.password', $mailSetting->password);

        /** Set Broadcasting Config */
        Config::set('broadcasting.connections.pusher.key', $pusherSetting->pusher_key);
        Config::set('broadcasting.connections.pusher.secret', $pusherSetting->pusher_secret);
        Config::set('broadcasting.connections.pusher.app_id', $pusherSetting->pusher_app_id);
        Config::set('broadcasting.connections.pusher.options.host', "api-" . $pusherSetting->pusher_cluster . ".pusher.com");

        /** Share variables to all views */
        View::composer('*', function ($view) use ($generalSetting, $logoSetting, $pusherSetting) {
            $view->with([
                'settings' => $generalSetting,
                'logoSetting' => $logoSetting,
                'pusherSetting' => $pusherSetting
            ]);
        });
    }

}
