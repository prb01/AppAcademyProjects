class AddLikesConstraint < ActiveRecord::Migration[5.2]
  def up
    execute(<<-SQL)
    ALTER TABLE likes 
    ADD CONSTRAINT only_like_one_of_artwork_or_comment 
    CHECK (
      (comment_id IS NOT NULL AND artwork_id IS NULL) OR
      (comment_id IS NULL AND artwork_id IS NOT NULL)
    );
    SQL
  end

  def down
    execute(<<-SQL)
    ALTER TABLE likes 
    DROP CONSTRAINT only_like_one_of_artwork_or_comment;
    SQL
  end
end
