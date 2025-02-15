/**
 * Copyright (c) 2018, Andrew Fawcett
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *      this list of conditions and the following disclaimer in the documentation
 *      and/or other materials provided with the distribution.
 * - Neither the name of the Andrew Fawcett, nor the names of its contributors
 *      may be used to endorse or promote products derived from this software without
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

@IsTest
private class di_InjectorComponentControllerTest {
    
    @isTest
    static void exerciseMethod() {
        di_InjectorComponentController componentInjector = new di_InjectorComponentController();
        componentInjector.BindingNameValue = 'Return_Hello_World';
        componentInjector.ParametersValue = (Object) 'myString';
        componentInjector.getInject();
    }

    @isTest
    static void givenWrongBindingNameValueWhenGetInjectThenThrowException(){
        //given
        di_InjectorComponentController newObj = new di_InjectorComponentController();
        String BindingNameValue = 'flow_AccountRecord_VF';
        Object ParametersValue = 'Account';
        try {
        //When
        newObj.getInject();
        } catch(Exception e){
            //Then
            System.assertEquals(e.getMessage().contains('List index out of bounds'), true, 'Correct exception is not thrown');
        }
    }

    @isTest
    static void givenFlowNameWhenGetInjectorFlowProxyInstanceThenMethodCall(){
        di_InjectorComponentController newObj = new di_InjectorComponentController();
        newObj.getInjectorFlowProxyInstance('HelloWorld', 'Account');
    }

}