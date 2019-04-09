import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';
import { FormsModule     } from '@angular/forms';
import { HttpModule      } from '@angular/http';
import { HttpClientModule,
         HttpClientXsrfModule
                         } from '@angular/common/http';
import { RouterModule    } from '@angular/router';

import { AppComponent } from './component/app.component';
import { AppProjectComponent     } from './component/app-project.component';
import { AppWorkComponent     } from './component/app-work.component';

import { AppRoutingModule } from './app-routing.module';

@NgModule({
  declarations:
    [
    AppComponent,
    AppProjectComponent,
    AppWorkComponent,
    
    ],
  imports:
    [
    BrowserModule,
    FormsModule,
    HttpModule,
    HttpClientModule,
    HttpClientXsrfModule.disable(),
    AppRoutingModule
    ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
