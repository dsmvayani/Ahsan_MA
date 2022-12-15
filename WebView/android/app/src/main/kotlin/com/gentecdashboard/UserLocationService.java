package com.gentecdashboard;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Header;
import retrofit2.http.POST;

public interface UserLocationService {
    @POST("GSAPI/User/InsertDataFromApp")
    Call<Object> InsertUserLocation(@Header("Authorization") String token, @Body Object object);
}
