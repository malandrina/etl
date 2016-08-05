defmodule Etl do
  import Postgrex.Timestamp

  def main(_argv) do
    {:ok, sql_server_pid} = Tds.Connection.start_link(
      hostname: "hostname",
      username: "username",
      password: "password",
      database: "database",
    )
    {:ok, sql_server_result} = Tds.Connection.query(
      sql_server_pid,
      """
        SELECT TOP 1000
          Id,
          fkEntityId,
          fkUserId,
          fkJobId,
          fkMasterJobSubCategoryId,
          fkCareerLevelId,
          Title,
          HiringEntityAsString,
          LocationAsString,
          LocationAsZip,
          Description,
          FullOrPartTime,
          HideExpiration,
          BaseSalary,
          TotalCompensation,
          GraphicURL,
          NextStepContent,
          VerificationCode,
          IsFutureConsiderationPosition,
          IsActive,
          IsFollowedUp,
          fkUserId_FollowUp,
          DateFollowedUp,
          WasNeverHired,
          DateExpires,
          A_ApplicantCount,
          TotalOfflineHires,
          InternalJobId,
          DateCreated,
          DateModified,
          fkCountryId,
          ForwardingURL,
          AllowVideoResumes,
          SharedKey,
          CanAnnounceHiring,
          AllowMobileAccess
        FROM
          Job
      """,
      []
    )

    {:ok, postgrex_pid} = Postgrex.start_link(
      hostname: "hostname",
      database: "database",
    )

    Enum.each sql_server_result.rows, fn row ->
      row = Enum.map row, &shenanigans/1

      Postgrex.query(postgrex_pid, """
        INSERT INTO legacy_jobs (
          legacy_id,
          legacy_entity_id,
          legacy_tmw_user_id,
          legacy_job_id,
          legacy_master_job_subcategory_id,
          legacy_career_level_id,
          title,
          hiring_entity_as_string,
          location_as_string,
          location_as_zip,
          description_html,
          full_or_part_time,
          hide_expiration,
          base_salary,
          total_compensation,
          graphic_url,
          next_step_content,
          verification_code,
          is_future_consideration_position,
          is_active,
          is_followed_up,
          legacy_tmw_user_id_follow_up,
          date_followed_up,
          was_never_hired,
          date_expires,
          applicant_count,
          total_offline_hires,
          internal_job_id,
          date_created,
          date_modified,
          legacy_country_id,
          forwarding_url,
          allow_video_resumes,
          shared_key,
          can_announce_hiring,
          allow_mobile_access,
          created_at,
          updated_at
        ) VALUES (
          $1,
          $2,
          $3,
          $4,
          $5,
          $6,
          $7,
          $8,
          $9,
          $10,
          $11,
          $12,
          $13,
          $14,
          $15,
          $16,
          $17,
          $18,
          $19,
          $20,
          $21,
          $22,
          $23,
          $24,
          $25,
          $26,
          $27,
          $28,
          $29,
          $30,
          $31,
          $32,
          $33,
          $34,
          $35,
          $36,
          now(),
          now()
        )
      """, row)
    end

    IO.puts "done"
  end

  defp shenanigans({{year, month, day}, {hour, min, sec, usec}}) do
    %Postgrex.Timestamp{year: year, month: month, day: day, hour: hour, min: min, sec: sec, usec: usec}
  end
  defp shenanigans(x) do
    x
  end
end
